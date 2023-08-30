-- CONSTANTS
local hl_prefix = "PaxLines"
-- HELPERS, aka lib
local lib = {}
-- Takes the section name and a string
-- Prefixes the string with the correct highlight group string
-- Format of that string is %#highlight_group#
function lib.prepend_hl_group(name, s)
    local hl_group = ("%%#%s%s#"):format(hl_prefix, name)
    return hl_group .. s
end

-- prefixes the section name with the hl_prefix
function lib.get_hl_group(section_name)
    return string.format("%%#%s%s#", hl_prefix, section_name)
end

-- opts = {
-- name = string => used to store the function and name the hl group
-- content = string | function
-- minwid = number
-- maxwid = number
-- justify = boolean
-- }
function lib.generate_status_string(opts)
    local content = opts.content
    local minwid = opts.minwid
    local maxwid = opts.maxwid
    local justify = opts.justify
    local name = opts.name
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
    local spacing_count = 1
    local spacing = string.rep(" ", spacing_count)

    for i, section in ipairs(sections) do
        local should_space_start = i > 1
        local should_space_end = i < #sections

        -- do the pre-spacing
        if should_space_start then
            result = spacing .. result
        end

        -- do the actual display string
        if type(section) == "string" then
            result = result .. section
        elseif type(section) == "function" then
            result = result .. self:add_function_section(section)
        end

        -- do the post-spacing
        if should_space_end then
            result = result .. spacing
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

function sections.separator()
    return "%="
end

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

-- TODO figure out why this isn't working... think this should work like the
-- (working) diagnostics section
function sections.project()
    local workspace_path = vim.lsp.buf.list_workspace_folders()[1]
    local no_workspace = workspace_path == nil

    if no_workspace then
        return lib.prepend_hl_group("NORMAL", "PROJECT")
    end

    -- clunky, but not sure how to do this cleanly
    local path_parts = {}
    for part in string.gmatch(workspace_path, "[^/]+") do
        table.insert(path_parts, part)
    end
    return lib.prepend_hl_group("NORMAL", path_parts[#path_parts])
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
    local diagnostic_levels = {
        { id = vim.diagnostic.severity.ERROR, sign = "E" },
        { id = vim.diagnostic.severity.WARN, sign = "W" },
        { id = vim.diagnostic.severity.INFO, sign = "I" },
        { id = vim.diagnostic.severity.HINT, sign = "H" },
    }
    local get_diagnostic_count = function(id)
        return #vim.diagnostic.get(0, { severity = id })
    end

    -- Assumption: there are no attached clients if table
    -- `vim.lsp.buf_get_clients()` is empty
    local clients = vim.lsp.buf_get_clients()
    local no_client_attached = next(clients) == nil
    if no_client_attached then
        return ""
    end

    -- Construct diagnostic info using predefined order
    local t = {}
    for _, level in ipairs(diagnostic_levels) do
        local n = get_diagnostic_count(level.id)
        -- Add level info only if diagnostic is present
        if n > 0 then
            table.insert(t, string.format(" %s%s", level.sign, n))
        end
    end

    local icon = "LSP"
    if vim.tbl_count(t) == 0 then
        return ("%s -"):format(icon)
    end
    return string.format("%s%s", icon, table.concat(t, ""))
end

-- search for the rhs of the statusline, optional
function sections.search()
    if vim.v.hlsearch == 0 then
        return ""
    end

    -- making this pcall with { recompute = false } may help performance
    local ok, s_count = pcall(vim.fn.searchcount, { recompute = true })
    if not ok or s_count.current == nil or s_count.total == 0 then
        return ""
    end

    if s_count.incomplete == 1 then
        return "?/?"
    end

    local too_many = (">%d"):format(s_count.maxcount)
    local current = s_count.current > s_count.maxcount and too_many or s_count.current
    local total = s_count.total > s_count.maxcount and too_many or s_count.total
    return ("%s/%s"):format(current, total)
end

-- TODO make this display the highlighted dimensions when in a visual mode
-- see https://neovim.io/doc/user/builtin.html#virtcol()
function sections.location()
    return '%l:%-2{virtcol(".") - 1}'
end

-- hold off doing these until git fugitive added
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
    sections.separator,
    sections.mode,
    sections.separator,
    sections.search,
    sections.location,
    sections.git_file,
    sections.file,
    sections.mode_repeater,
}

vim.opt.statusline = lib:parse(statusline)
