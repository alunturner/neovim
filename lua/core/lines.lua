-- CONSTANTS
local hl_prefix = "PaxLines"
local separator = "%="
-- HELPERS, aka lib
local lib = {}
-- Takes the section name and a string
-- Prefixes the string with the correct highlight group string
-- Format of that string is %#highlight_group#
function lib.get_hl_group(name, s)
    local hl_group = ("%%#%s%s#"):format(hl_prefix, name)
    return hl_group .. s
end

lib.lookup = {}
lib.lookup._items = 1

function lib.lookup._get(i)
    return lib.lookup[i]
end

function lib:create_status_string(s)
    self.lookup[self.lookup._items] = s
    self.lookup._items = self.lookup._items + 1
    return s
end

function lib:create_status_function(fn)
    self.lookup[self.lookup._items] = fn
    self.lookup._items = self.lookup._items + 1
    return "%{%v:lua.PaxLines.lib.lookup._get(" .. string.format("%d", self.lookup._items - 1) .. ")()%}"
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
            result = result .. self:create_status_string(section)
        elseif type(section) == "function" then
            result = result .. self:create_status_function(section)
        elseif type(section) == "table" then
            -- TODO handle tables to allow for nesting
        end
    end
    return result
end

-- mod
local mod = {}

function mod.mode()
    local modes = {
        ["n"] = "N",
        ["no"] = "N",
        ["nov"] = "N",
        ["noV"] = "N",
        ["no\22"] = "N",
        ["niI"] = "N",
        ["niR"] = "N",
        ["niV"] = "N",
        ["nt"] = "N",
        ["ntT"] = "N",
        ["v"] = "V",
        ["vs"] = "V",
        ["V"] = "V",
        ["Vs"] = "V",
        ["\22"] = "V",
        ["\22s"] = "V",
        ["s"] = "S",
        ["S"] = "S",
        ["CTRL-S"] = "S",
        ["i"] = "I",
        ["ic"] = "I",
        ["ix"] = "I",
        ["R"] = "R",
        ["Rc"] = "R",
        ["Rx"] = "R",
        ["Rvc"] = "R",
        ["Rvx"] = "R",
        ["c"] = "C",
        ["cv"] = "E",
        ["r"] = "N",
        ["rm"] = "N",
        ["r?"] = "N",
        ["!"] = "N",
        ["t"] = "T",
    }
    local mode = modes[vim.api.nvim_get_mode().mode]
    return lib.get_hl_group(mode, " " .. mode .. " ")
end

function mod.filetype()
    local filetype = string.upper(vim.bo.filetype)
    if filetype == "" then
        return ""
    end
    return lib.get_hl_group("Filetype", " " .. filetype .. " ")
end

-- This can be a raw string, no need for expression as it is built into vim
function mod.file()
    return lib.get_hl_group("File", " %m %f ")
end

function mod.project()
    return lib.get_hl_group("Project", " %F ")
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
    info = info .. lib.get_hl_group("GitDiffInsertion", " ")
    if insertions ~= 0 then
        info = info .. lib.get_hl_group("GitDiffInsertion", "+") .. tostring(insertions)
    end
    if insertions ~= 0 and deletions ~= 0 then
        info = info .. " " -- add space separator
    end
    if deletions ~= 0 then
        info = info .. lib.get_hl_group("GitDiffDeletion", "-") .. tostring(deletions)
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
