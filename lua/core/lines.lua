-- CONSTANTS
local hl_prefix = "PaxLines"
local separator = "%="
-- HELPERS, aka lib
local lib = {}
-- Takes the section name and a string
-- Prefixes the string with the correct highlight group string
-- Format of that string is %#highlight_group#
function lib.prepend_hl_group(name, s)
    local hl_group = ("%%#%s%s#"):format(hl_prefix, name)
    return hl_group .. s
end

lib.sections = {}
lib.next_section_index = 1

-- this needs to be a . defined method to allow it to be called in
-- :add_function_section (at least I think this is the case)
function lib.get_section(index)
    return lib.sections[index]
end

function lib:append_section(section)
    self.sections[self.next_section_index] = section
    self.next_section_index = self.next_section_index + 1
end

function lib:add_string_section(s)
    self:append_section(s)
    return s
end

function lib:add_function_section(fn)
    self:append_section(fn)
    return "%{%v:lua.PaxLines.lib.get_section(" .. string.format("%d", self.next_section_index - 1) .. ")()%}"
end

-- we call this with a list of SECTIONS
-- each SECTION can be one of:
-- STRING - which just gets inserted
-- FUNCTION - which will get called, and the result will be inserted
-- TABLE - which has a highlight group created, then it's subsections inserted
--{
--  name = <used as highlight group name>,
--  sections = {...list of more sections to insert}
--}
function lib:parse(sections)
    local result = ""
    for _, section in pairs(sections) do
        if type(section) == "string" then
            result = result .. self:add_string_section(section)
        elseif type(section) == "function" then
            result = result .. self:add_function_section(section)
        elseif type(section) == "table" then
            -- TODO handle tables to allow for nesting
        end
    end
    return result
end

-- mod
local mod = {}

function mod.mode()
    -- Lifted from Lualine
    -- TODO get these highlight groups in the theme
    -- stylua: ignore start
    local modes = {
        ["n"]       = "NORMAL",
        ["no"]      = "O-PENDING",
        ["nov"]     = "O-PENDING",
        ["noV"]     = "O-PENDING",
        ["no\22"]   = "O-PENDING",
        ["niI"]     = "NORMAL",
        ["niR"]     = "NORMAL",
        ["niV"]     = "NORMAL",
        ["nt"]      = "NORMAL",
        ["ntT"]     = "NORMAL",
        ["v"]       = "VISUAL",
        ["vs"]      = "VISUAL",
        ["V"]       = "V-LINE",
        ["Vs"]      = "V-LINE",
        ["\22"]     = "V-BLOCK",
        ["\22s"]    = "V-BLOCK",
        ["s"]       = "SELECT",
        ["S"]       = "S-LINE",
        ["\19"]     = "S-BLOCK",
        ["i"]       = "INSERT",
        ["ic"]      = "INSERT",
        ["ix"]      = "INSERT",
        ["R"]       = "REPLACE",
        ["Rc"]      = "REPLACE",
        ["Rx"]      = "REPLACE",
        ["Rv"]      = "V-REPLACE",
        ["Rvc"]     = "V-REPLACE",
        ["Rvx"]     = "V-REPLACE",
        ["c"]       = "COMMAND",
        ["cv"]      = "EX",
        ["ce"]      = "EX",
        ["r"]       = "REPLACE",
        ["rm"]      = "MORE",
        ["r?"]      = "CONFIRM",
        ["!"]       = "SHELL",
        ["t"]       = "TERMINAL",
    }
    -- stylua: ignore end
    local mode = modes[vim.api.nvim_get_mode().mode]
    return lib.prepend_hl_group(mode, " " .. mode .. " ")
end

function mod.filetype()
    local filetype = string.upper(vim.bo.filetype)
    if filetype == "" then
        return ""
    end
    return lib.prepend_hl_group("Filetype", " " .. filetype .. " ")
end

-- This can be a raw string, no need for expression as it is built into vim
function mod.file()
    return lib.prepend_hl_group("File", " %m %f ")
end

function mod.project()
    return lib.prepend_hl_group("Project", " %F ")
end

-- {{{ git status
-- return next line from i, and return the position after '\n'
local function get_line(str, i)
    local result = ""
    i = i or 1
    while i <= str:len() do
        if str:sub(i, i) == "\n" then
            return result, i + 1
        end
        result = result .. str:sub(i, i)
        i = i + 1
    end
    return ""
end

-- function that takes form "[number]\t[number]" and returns [number], [number]
local function parse_nums(str)
    local result = {}
    for n in str:gmatch("(%d+)\t") do
        table.insert(result, n)
    end
    return tonumber(result[1]), tonumber(result[2])
end

-- this parses the output from "git diff --numstat [filename]"
local function git_diff_parse(diff_output)
    local info = ""
    local insertions, deletions = 0, 0
    local ins, del = 0, 0
    local line, i = get_line(diff_output, 1)
    while line ~= "" do
        ins, del = parse_nums(line)
        insertions = insertions + ins
        deletions = deletions + del
        line, i = get_line(diff_output, i)
    end
    info = info .. lib.prepend_hl_group("GitDiffInsertion", " ")
    if insertions ~= 0 then
        info = info .. lib.prepend_hl_group("GitDiffInsertion", "+") .. tostring(insertions)
    end
    if insertions ~= 0 and deletions ~= 0 then
        info = info .. " " -- add space separator
    end
    if deletions ~= 0 then
        info = info .. lib.prepend_hl_group("GitDiffDeletion", "-") .. tostring(deletions)
    end
    return info == "" and "" or info .. " "
end

--[[
LibLuv seems to always call "onread" with nil data even if there was chunks
previously( I assume its when it reaches EOF ). This means to distinguish
between "" and that nil that is by checking if we encounter 2 subsequent
nil values
--]]
local nnil = 0
local function onread(err, data)
    if data then
        nnil = 0 -- reset nnil if we get data
        mod.git_diff_output = git_diff_parse(data)
    elseif nnil >= 2 then
        mod.git_diff_output = ""
    else
        nnil = nnil + 1
    end
end

mod.git_diff_output = ""

-- shows insertions and deletions in current worktree file
function mod.git_diff()
    local bufname = vim.api.nvim_buf_get_name(0)
    local stdout = vim.loop.new_pipe()
    local handle -- pre declaration neccesary
    handle = vim.loop.spawn("git", {
        args = { "diff", "--numstat", bufname },
        stdio = { nil, stdout, nil },
    }, function(status)
        stdout:read_stop()
        stdout:close()
        handle:close()
    end)
    vim.loop.read_start(stdout, onread)
    return mod.git_diff_output
end
-- }}}

-- global for module
PaxLines = {}
PaxLines.lib = lib

local winbar = {
    mod.project,
    separator,
    separator,
    mod.file,
}
local statusline = {
    separator,
    mod.mode,
    mod.filetype,
    mod.git_diff,
}

vim.opt.statusline = lib:parse(statusline)
vim.opt.winbar = lib:parse(winbar)
