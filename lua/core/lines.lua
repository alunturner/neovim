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
local sections = {
    mode_table = {
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
    },
}

-- Display the full word for the current mode
function sections.mode()
    local nvim_code = vim.api.nvim_get_mode().mode
    local display_text = sections.mode_table[nvim_code]

    -- remove the hyphens from those names that have them
    local hl_name = string.gsub(display_text, "(%w+)-(%w+)", "%1%2")
    return lib.prepend_hl_group(hl_name, display_text)
end

function sections.file()
    return "%m %t"
end

-- TODO, figure out why this doesn't work, I presume it needs to update?
function sections.project()
    local clients = vim.lsp.buf_get_clients()
    local no_client_attached = next(clients) == nil

    if no_client_attached then
        return ""
    end

    for _, client in ipairs(clients) do
        if client.root_dir ~= nil then
            return string.format("%s", "hello!")
        end
    end

    return ""
end

-- a mode repeater for the winline
function sections.mode_repeater()
    local nvim_code = vim.api.nvim_get_mode().mode
    local display_text = sections.mode_table[nvim_code]

    -- remove the hyphens from those names that have them
    local hl_name = string.gsub(display_text, "(%w+)-(%w+)", "%1%2")
    local repeater_length = 1
    return lib.prepend_hl_group(hl_name, string.rep(" ", repeater_length))
end

-- diagnostics for the lhs of the statusline, optional
function sections.diagnostics()
    return "DIAGNOSTICS"
end

-- search for the rhs of the statusline, optional
function sections.search()
    return "SEARCH"
end

-- location for the rhs of the statusline
function sections.location()
    return "LOCATION"
end

-- git status for the extreme left
function sections.git_project()
    return "GIT STATUS"
end

-- git diff for the extreme right
function sections.git_file()
    return "GIT DIFF"
end

-- git branch for the extreme left
function sections.git_branch()
    return "GIT BRANCH"
end

-- global for module
PaxLines = {}
PaxLines.lib = lib

local statusline = {
    sections.mode_repeater,
    sections.project,
    sections.git_branch,
    sections.git_project,
    sections.diagnostics,
    separator,
    sections.mode,
    separator,
    sections.search,
    sections.location,
    sections.git_file,
    sections.file,
    sections.mode_repeater,
}

vim.opt.statusline = lib:parse(statusline)
