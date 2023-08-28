-- STOLEN FROM:
--- *mini.statusline* Statusline
--- *MiniStatusline*
---
--- MIT License Copyright (c) 2021 Evgeni Chasnovski
---
--- ==============================================================================
--- # Highlight groups~
---
--- Highlight depending on mode (second output from |MiniStatusline.section_mode|):
--- * `MiniStatuslineModeNormal` - Normal mode.
--- * `MiniStatuslineModeInsert` - Insert mode.
--- * `MiniStatuslineModeVisual` - Visual mode.
--- * `MiniStatuslineModeReplace` - Replace mode.
--- * `MiniStatuslineModeCommand` - Command mode.
--- * `MiniStatuslineModeOther` - other modes (like Terminal, etc.).
---
--- Highlight used in default statusline:
--- * `MiniStatuslineDevinfo` - for "dev info" group
---   (|MiniStatusline.section_git| and |MiniStatusline.section_diagnostics|).
--- * `MiniStatuslineFilename` - for |MiniStatusline.section_filename| section.
--- * `MiniStatuslineFileinfo` - for |MiniStatusline.section_fileinfo| section.
---
--- Other groups:
--- * `MiniStatuslineInactive` - highliting in not focused window.
---
--- To change any highlight group, modify it directly with |:highlight|.
---
--- # Disabling~
---
--- To disable (show empty statusline), set `vim.g.ministatusline_disable`
--- (globally) or `vim.b.ministatusline_disable` (for a buffer) to `true`.
--- Considering high number of different scenarios and customization
--- intentions, writing exact rules for disabling module's functionality is
--- left to user. See |mini.nvim-disabling-recipes| for common recipes.

-- Module definition ==========================================================
local MiniStatusline = {}
local H = {}

-- Default content ------------------------------------------------------------
-- TODO figure out how to make the separators play nicely - think they'll have
-- to be handled in the combine_groups function
local left_separator = ""
local right_separator = ""
local custom_active = function()
    local mode_short, mode_long, mode_hl = MiniStatusline.section_mode()
    local git = MiniStatusline.section_git()
    local diagnostics = MiniStatusline.section_diagnostics()
    local filename = MiniStatusline.section_filename()
    local location = MiniStatusline.section_location()

    -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
    -- correct padding with spaces between groups (accounts for 'missing'
    -- sections, etc.)
    return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode_long } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFileinfo", strings = { location } },
        { hl = mode_hl, strings = { mode_short } },
    })
end

local custom_inactive = function()
    return "%#MiniStatuslineInactive#%F%="
end

-- CONFIG
MiniStatusline.config = {
    -- Content of (in)active statuslines as functions which return statusline string.
    -- See `:h statusline` and code of default contents (used instead of `nil`).
    content = {
        active = custom_active,
        inactive = custom_inactive,
    },
}

--- Module setup
MiniStatusline.setup = function()
    -- Export module
    _G.MiniStatusline = MiniStatusline

    -- Define behavior
    H.create_autocommands()

    -- Disable built-in statusline in Quickfix window
    vim.g.qf_disable_statusline = 1

    -- Create default highlighting
    H.create_default_hl()
end

-- Module functionality =======================================================
--- Compute content for active window
MiniStatusline.active = function()
    if H.is_disabled() then
        return ""
    end

    return custom_active()
end

--- Compute content for inactive window
MiniStatusline.inactive = function()
    if H.is_disabled() then
        return ""
    end

    return custom_inactive()
end

--- Combine groups of sections
---
--- Each group can be either a string or a table with fields `hl` (group's
--- highlight group) and `strings` (strings representing sections).
---
--- General idea of this function is as follows;
--- - String group is used as is (useful for special strings like `%<` or `%=`).
--- - Each table group has own highlighting in `hl` field (if missing, the
---   previous one is used) and string parts in `strings` field. Non-empty
---   strings from `strings` are separated by one space. Non-empty groups are
---   separated by two spaces (one for each highlighting).
MiniStatusline.combine_groups = function(groups)
    local parts = vim.tbl_map(function(s)
        if type(s) == "string" then
            return s
        end
        if type(s) ~= "table" then
            return ""
        end

        local string_arr = vim.tbl_filter(function(x)
            return type(x) == "string" and x ~= ""
        end, s.strings or {})
        local str = table.concat(string_arr, " ")

        -- Use previous highlight group
        if s.hl == nil then
            return (" %s "):format(str)
        end

        -- Allow using this highlight group later
        if str:len() == 0 then
            return string.format("%%#%s#", s.hl)
        end

        return string.format("%%#%s# %s ", s.hl, str)
    end, groups)

    return table.concat(parts, "")
end

-- Sections ===================================================================
-- Functions should return output text without whitespace on sides.
-- Return empty string to omit section.

--- Section for Vim |mode()|
---
--- Short output is returned if window width is lower than `args.trunc_width`.
MiniStatusline.section_mode = function()
    local mode_info = H.modes[vim.fn.mode()]
    return mode_info.short, mode_info.long, mode_info.hl
end

--- Section for Git information
---
--- Normal output contains name of `HEAD` (via |b:gitsigns_head|) and chunk
--- information (via |b:gitsigns_status|). Short output - only name of `HEAD`.
--- Note: requires 'lewis6991/gitsigns' plugin.
---
--- Short output is returned if window width is lower than `args.trunc_width`.
MiniStatusline.section_git = function()
    -- TODO integrate git fugitive here
    if H.isnt_normal_buffer() then
        return ""
    end
    local head = vim.b.gitsigns_head or "-"
    local signs = vim.b.gitsigns_status or ""
    local icon = "" or "Git"

    if signs == "" then
        if head == "-" or head == "" then
            return ""
        end
        return string.format("%s %s", icon, head)
    end
    return string.format("%s %s %s", icon, head, signs)
end

--- Section for Neovim's builtin diagnostics
---
--- Shows nothing if there is no attached LSP clients or for short output.
--- Otherwise uses builtin Neovim capabilities to compute and show number of
--- errors ('E'), warnings ('W'), information ('I'), and hints ('H').
---
--- Short output is returned if window width is lower than `args.trunc_width`.
MiniStatusline.section_diagnostics = function()
    -- Assumption: there are no attached clients if table
    -- `vim.lsp.buf_get_clients()` is empty
    local hasnt_attached_client = next(vim.lsp.buf_get_clients()) == nil
    local dont_show_lsp = H.isnt_normal_buffer() or hasnt_attached_client
    if dont_show_lsp then
        return ""
    end

    -- Construct diagnostic info using predefined order
    local t = {}
    for _, level in ipairs(H.diagnostic_levels) do
        local n = H.get_diagnostic_count(level.id)
        -- Add level info only if diagnostic is present
        if n > 0 then
            table.insert(t, string.format(" %s%s", level.sign, n))
        end
    end

    local icon = "" or "LSP"
    if vim.tbl_count(t) == 0 then
        return ("%s -"):format(icon)
    end
    return string.format("%s%s", icon, table.concat(t, ""))
end

--- Section for file name
---
--- Show full file name or relative in short output.
---
--- Short output is returned if window width is lower than `args.trunc_width`.
MiniStatusline.section_filename = function()
    -- In terminal always use plain name
    if vim.bo.buftype == "terminal" then
        return "%t"
    else
        -- Use fullpath if not truncated
        return "%F%m%r"
    end
end

--- Section for file information
---
--- Short output contains only extension and is returned if window width is
--- lower than `args.trunc_width`.
MiniStatusline.section_fileinfo = function()
    local filetype = vim.bo.filetype

    -- Don't show anything if can't detect file type or not inside a "normal
    -- buffer"
    if (filetype == "") or H.isnt_normal_buffer() then
        return ""
    end

    -- Add filetype icon
    local icon = H.get_filetype_icon()
    if icon ~= "" then
        filetype = string.format("%s %s", icon, filetype)
    end

    -- Construct output string with extra file info
    local encoding = vim.bo.fileencoding or vim.bo.encoding
    local format = vim.bo.fileformat

    return string.format("%s %s[%s]", filetype, encoding, format)
end

--- Section for location inside buffer
---
--- Show location inside buffer in the form:
--- - Normal: '<cursor line>|<total lines>│<cursor column>|<total columns>'.
--- - Short: '<cursor line>│<cursor column>'.
---
--- Short output is returned if window width is lower than `args.trunc_width`.
MiniStatusline.section_location = function()
    -- Use `virtcol()` to correctly handle multi-byte characters
    return '%l|%L│%2v|%-2{virtcol("$") - 1}'
end

--- Section for current search count
---
--- Show the current status of |searchcount()|. Empty output is returned if
--- window width is lower than `args.trunc_width`, search highlighting is not
--- on (see |v:hlsearch|), or if number of search result is 0.
---
--- `args.options` is forwarded to |searchcount()|.  By default it recomputes
--- data on every call which can be computationally expensive (although still
--- usually same order of magnitude as 0.1 ms). To prevent this, supply
--- `args.options = {recompute = false}`.
MiniStatusline.section_searchcount = function(args)
    if vim.v.hlsearch == 0 then
        return ""
    end
    -- `searchcount()` can return errors because it is evaluated very often in
    -- statusline. For example, when typing `/` followed by `\(`, it gives E54.
    local ok, s_count = pcall(vim.fn.searchcount, (args or {}).options or { recompute = true })
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

-- Helper data ================================================================
-- Showed diagnostic levels
H.diagnostic_levels = {
    { id = vim.diagnostic.severity.ERROR, sign = "E" },
    { id = vim.diagnostic.severity.WARN, sign = "W" },
    { id = vim.diagnostic.severity.INFO, sign = "I" },
    { id = vim.diagnostic.severity.HINT, sign = "H" },
}

-- Helper functionality =======================================================
-- Settings -------------------------------------------------------------------
H.create_autocommands = function()
    local augroup = vim.api.nvim_create_augroup("MiniStatusline", {})

    local au = function(event, pattern, callback, desc)
        vim.api.nvim_create_autocmd(event, { group = augroup, pattern = pattern, callback = callback, desc = desc })
    end

    local set_active = function()
        vim.wo.statusline = "%!v:lua.MiniStatusline.active()"
    end
    au({ "WinEnter", "BufEnter" }, "*", set_active, "Set active statusline")

    local set_inactive = function()
        vim.wo.statusline = "%!v:lua.MiniStatusline.inactive()"
    end
    au({ "WinLeave", "BufLeave" }, "*", set_inactive, "Set inactive statusline")
end

H.create_default_hl = function()
    local set_default_hl = function(name, data)
        data.default = true
        vim.api.nvim_set_hl(0, name, data)
    end

    set_default_hl("MiniStatuslineModeNormal", { link = "Cursor" })
    set_default_hl("MiniStatuslineModeInsert", { link = "DiffChange" })
    set_default_hl("MiniStatuslineModeVisual", { link = "DiffAdd" })
    set_default_hl("MiniStatuslineModeReplace", { link = "DiffDelete" })
    set_default_hl("MiniStatuslineModeCommand", { link = "DiffText" })
    set_default_hl("MiniStatuslineModeOther", { link = "IncSearch" })

    set_default_hl("MiniStatuslineDevinfo", { link = "StatusLine" })
    set_default_hl("MiniStatuslineFilename", { link = "StatusLineNC" })
    set_default_hl("MiniStatuslineFileinfo", { link = "StatusLine" })
    set_default_hl("MiniStatuslineInactive", { link = "StatusLineNC" })
end

H.is_disabled = function()
    return vim.g.ministatusline_disable == true or vim.b.ministatusline_disable == true
end

H.get_config = function(config)
    return vim.tbl_deep_extend("force", MiniStatusline.config, vim.b.ministatusline_config or {}, config or {})
end

-- Mode -----------------------------------------------------------------------
-- Custom `^V` and `^S` symbols to make this file appropriate for copy-paste
-- (otherwise those symbols are not displayed).
local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)

H.modes = setmetatable({
    ["n"] = { long = "NORMAL", short = "N", hl = "MiniStatuslineModeNormal" },
    ["v"] = { long = "VISUAL", short = "V", hl = "MiniStatuslineModeVisual" },
    ["V"] = { long = "V-LINE", short = "V-L", hl = "MiniStatuslineModeVisual" },
    [CTRL_V] = { long = "V-BLOCK", short = "V-B", hl = "MiniStatuslineModeVisual" },
    ["s"] = { long = "SELECT", short = "S", hl = "MiniStatuslineModeVisual" },
    ["S"] = { long = "S-LINE", short = "S-L", hl = "MiniStatuslineModeVisual" },
    [CTRL_S] = { long = "S-BLOCK", short = "S-B", hl = "MiniStatuslineModeVisual" },
    ["i"] = { long = "INSERT", short = "I", hl = "MiniStatuslineModeInsert" },
    ["R"] = { long = "REPLACE", short = "R", hl = "MiniStatuslineModeReplace" },
    ["c"] = { long = "COMMAND", short = "C", hl = "MiniStatuslineModeCommand" },
    ["r"] = { long = "PROMPT", short = "P", hl = "MiniStatuslineModeOther" },
    ["!"] = { long = "SHELL", short = "Sh", hl = "MiniStatuslineModeOther" },
    ["t"] = { long = "TERMINAL", short = "T", hl = "MiniStatuslineModeOther" },
}, {
    -- By default return 'Unknown' but this shouldn't be needed
    __index = function()
        return { long = "Unknown", short = "U", hl = "%#MiniStatuslineModeOther#" }
    end,
})

-- Utilities ------------------------------------------------------------------
H.isnt_normal_buffer = function()
    -- For more information see ":h buftype"
    return vim.bo.buftype ~= ""
end

H.get_diagnostic_count = function(id)
    return #vim.diagnostic.get(0, { severity = id })
end

MiniStatusline.setup()
