-- CONSTANTS
local hl_prefix = "PaxLines"
local percent_equals = { raw = true, value = "%=" }

-- HELPERS, aka lib
local lib = {}
-- We store any anded' highlight groups here so that we don't keep creating redundant highlight groups at runtime
function lib.set_hl(name)
    return ("%%#%s%s#"):format(hl_prefix, name)
end

function lib.set_hl_abs(name)
    return ("%%#%s#"):format(name)
end

function lib.unset_hl()
    return lib.set_hl_abs("Normal")
end

-- Adds highlight group infront of s
function lib.set_highlight(name, s, reset)
    if reset then
        return lib.set_hl(name) .. s .. lib.set_hl_abs("Normal")
    end
    return lib.set_hl(name) .. s
end

lib.lookup = {}
lib.lookup._items = 1

function lib.lookup._get(i)
    return lib.lookup[i]
end

function lib:create_status_item(fn)
    local item
    if not (type(fn) == "function") then
        item = function()
            return fn
        end
    else
        item = fn
    end
    self.lookup[self.lookup._items] = item
    self.lookup._items = self.lookup._items + 1
    return "%{%v:lua.PaxLines.lib.lookup._get(" .. string.format("%d", self.lookup._items - 1) .. ")()%}"
end

function lib:parse_config(config)
    local result = "%#Normal#"
    for _, v in pairs(config) do
        if type(v) == "table" then
            if v.raw then -- allows user to add something directly to statusline
                result = result .. v.value
                goto __break__
            end
            local minmax = ""
            if v.minwid then
                minmax = minmax .. tostring(v.minwid)
            end
            if v.maxwid then
                minmax = minmax .. "." .. tostring(v.maxwid)
            end
            local group = {}
            for _, item in ipairs(v) do
                table.insert(group, self:create_status_item(item))
            end
            local dash = ""
            if v.left_justify then
                dash = "-"
            end
            result = result .. string.format("%%%s%s(%s%%)", dash, minmax, table.concat(group, v.separator or " "))
        else
            result = result .. self:create_status_item(v)
        end
        ::__break__::
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
    return lib.set_highlight(mode, " " .. mode .. " ")
end

function mod.filetype()
    local filetype = string.upper(vim.bo.filetype)
    if filetype == "" then
        return ""
    end
    return lib.set_highlight("Filetype", " " .. filetype .. " ")
end

-- This can be a raw string, no need for expression as it is built into vim
function mod.file()
    return {
        raw = true,
        value = lib.set_highlight("File", " %m %f "),
    }
end

function mod.project()
    return {
        raw = true,
        value = lib.set_highlight("Project", " %F "),
    }
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
    local hl = lib.set_highlight
    info = info .. hl("GitDiffInsertion", " ")
    if insertions ~= 0 then
        info = info .. hl("GitDiffInsertion", "+") .. tostring(insertions)
    end
    if insertions ~= 0 and deletions ~= 0 then
        info = info .. " " -- add space separator
    end
    if deletions ~= 0 then
        info = info .. hl("GitDiffDeletion", "-") .. tostring(deletions)
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
    mod.project(),
    percent_equals,
    percent_equals,
    mod.file(),
}
local statusline = {
    percent_equals,
    mod.mode,
    mod.filetype,
    mod.git_diff,
}

vim.opt.statusline = lib:parse_config(statusline)
vim.opt.winbar = lib:parse_config(winbar)
