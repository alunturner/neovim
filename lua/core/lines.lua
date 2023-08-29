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

-- Call this with a list of sections, returns a string formatted as a line
-- STRING - can be magic or static, inserted as is
-- FUNCTION - will be called, must return a string which will then be inserted,
-- use a function to add highlight groups or dynamic behaviour
function lib:parse(sections)
    local result = ""
    for _, section in pairs(sections) do
        if type(section) == "string" then
            result = result .. self:add_string_section(section)
        elseif type(section) == "function" then
            result = result .. self:add_function_section(section)
        end
    end
    return result
end

-- mod
local mod = {}

-- Display the full word for the current mode
function mod.mode()
    -- (lifted from Lualine)
    local mode_table = {
        ["n"] = "NORMAL",
        ["no"] = "O-PENDING",
        ["nov"] = "O-PENDING",
        ["noV"] = "O-PENDING",
        ["no\22"] = "O-PENDING",
        ["niI"] = "NORMAL",
        ["niR"] = "NORMAL",
        ["niV"] = "NORMAL",
        ["nt"] = "NORMAL",
        ["ntT"] = "NORMAL",
        ["v"] = "VISUAL",
        ["vs"] = "VISUAL",
        ["V"] = "V-LINE",
        ["Vs"] = "V-LINE",
        ["\22"] = "V-BLOCK",
        ["\22s"] = "V-BLOCK",
        ["s"] = "SELECT",
        ["S"] = "S-LINE",
        ["\19"] = "S-BLOCK",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["ix"] = "INSERT",
        ["R"] = "REPLACE",
        ["Rc"] = "REPLACE",
        ["Rx"] = "REPLACE",
        ["Rv"] = "V-REPLACE",
        ["Rvc"] = "V-REPLACE",
        ["Rvx"] = "V-REPLACE",
        ["c"] = "COMMAND",
        ["cv"] = "EX",
        ["ce"] = "EX",
        ["r"] = "REPLACE",
        ["rm"] = "MORE",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERMINAL",
    }

    local nvim_code = vim.api.nvim_get_mode().mode
    local display_text = mode_table[nvim_code]

    -- remove the hyphens from those names that have them
    local hl_name = string.gsub(display_text, "(%w+)-(%w+)", "%1%2")
    return lib.prepend_hl_group(hl_name, display_text)
end

-- This can be a raw string, no need for expression as it is built into vim
function mod.file()
    return lib.prepend_hl_group("File", "%m %f")
end

function mod.project()
    return lib.prepend_hl_group("Project", "%F")
end

-- a mode repeater for the winline
function mod.mode_repeater()
    return "MODE REPEATER"
end

-- diagnostics for the lhs of the statusline
function mod.diagnostics()
    return "DIAGNOSTICS"
end

-- location for the rhs of the statusline
function mod.location()
    return "LOCATION"
end

-- git status for the extreme left
function mod.git_status()
    return "BRANCH AND STATUS"
end

-- git diff for the extreme right
function mod.git_diff()
    return "GIT DIFF"
end

-- global for module
PaxLines = {}
PaxLines.lib = lib

local winbar = {
    mod.project,
    separator,
    mod.mode_repeater,
    separator,
    mod.file,
}
local statusline = {
    mod.git_status,
    mod.diagnostics,
    separator,
    mod.mode,
    separator,
    mod.location,
    mod.git_diff,
}

vim.opt.statusline = lib:parse(statusline)
vim.opt.winbar = lib:parse(winbar)
