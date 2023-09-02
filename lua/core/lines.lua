-- TODO
-- sort out window width calculation
-- sort out layout
-- sort out colouring
-- add nice dividers
PaxLines = {}
local prefix = "PaxLines"
local function create_highlight(highlight)
    return string.format("%%#%s%s#", prefix, highlight)
end

local modes = {
    ["n"] = { display_text = "NORMAL", hl_name = "ModeNormal" },
    ["no"] = { display_text = "O-PENDING", hl_name = "ModePending" },
    ["nov"] = { display_text = "O-PENDING", hl_name = "ModePending" },
    ["noV"] = { display_text = "O-PENDING", hl_name = "ModePending" },
    ["no\22"] = { display_text = "O-PENDING", hl_name = "ModePending" },
    ["niI"] = { display_text = "NORMAL", hl_name = "ModeNormal" },
    ["niR"] = { display_text = "NORMAL", hl_name = "ModeNormal" },
    ["niV"] = { display_text = "NORMAL", hl_name = "ModeNormal" },
    ["nt"] = { display_text = "NORMAL", hl_name = "ModeNormal" },
    ["ntT"] = { display_text = "NORMAL", hl_name = "ModeNormal" },
    ["v"] = { display_text = "VISUAL", hl_name = "ModeVisual" },
    ["vs"] = { display_text = "VISUAL", hl_name = "ModeVisual" },
    ["V"] = { display_text = "V-LINE", hl_name = "ModeVisual" },
    ["Vs"] = { display_text = "V-LINE", hl_name = "ModeVisual" },
    ["\22"] = { display_text = "V-BLOCK", hl_name = "ModeVisual" },
    ["\22s"] = { display_text = "V-BLOCK", hl_name = "ModeVisual" },
    ["s"] = { display_text = "SELECT", hl_name = "ModeSelect" },
    ["S"] = { display_text = "S-LINE", hl_name = "ModeSelect" },
    ["\19"] = { display_text = "S-BLOCK", hl_name = "ModeSelect" },
    ["i"] = { display_text = "INSERT", hl_name = "ModeInsert" },
    ["ic"] = { display_text = "INSERT", hl_name = "ModeInsert" },
    ["ix"] = { display_text = "INSERT", hl_name = "ModeInsert" },
    ["R"] = { display_text = "REPLACE", hl_name = "ModeReplace" },
    ["Rc"] = { display_text = "REPLACE", hl_name = "ModeReplace" },
    ["Rx"] = { display_text = "REPLACE", hl_name = "ModeReplace" },
    ["Rv"] = { display_text = "V-REPLACE", hl_name = "ModeReplace" },
    ["Rvc"] = { display_text = "V-REPLACE", hl_name = "ModeReplace" },
    ["Rvx"] = { display_text = "V-REPLACE", hl_name = "ModeReplace" },
    ["c"] = { display_text = "COMMAND", hl_name = "ModeCommand" },
    ["cv"] = { display_text = "EX", hl_name = "ModeEx" },
    ["ce"] = { display_text = "EX", hl_name = "ModeEx" },
    ["r"] = { display_text = "REPLACE", hl_name = "ModeReplace" },
    ["rm"] = { display_text = "MORE", hl_name = "ModeOther" },
    ["r?"] = { display_text = "CONFIRM", hl_name = "ModeOther" },
    ["!"] = { display_text = "SHELL", hl_name = "ModeOther" },
    ["t"] = { display_text = "TERMINAL", hl_name = "ModeOther" },
}

local function set_global_mode()
    local current_mode = vim.api.nvim_get_mode().mode
    PaxLines.mode = modes[current_mode]
end
local function get_global_highlight()
    local current_mode_hl_name = PaxLines.mode.hl_name
    return create_highlight(current_mode_hl_name)
end

PaxLines.ModeRepeater = function()
    local content = " "
    return string.format("%s", content)
end
local function ModeRepeater()
    local call = "{%v:lua.PaxLines.ModeRepeater()%}"
    return string.format("%%%s", call)
end

PaxLines.Workspace = function()
    local workspace_path = vim.lsp.buf.list_workspace_folders()[1]
    local no_workspace = workspace_path == nil

    if no_workspace then
        return "[LSP]: Zzz"
    end

    -- clunky, but not sure how to do this cleanly
    local path_parts = {}
    for part in string.gmatch(workspace_path, "[^/]+") do
        table.insert(path_parts, part)
    end

    return path_parts[#path_parts]
end
local function Workspace()
    local highlight = create_highlight("Workspace")
    local call = "%-20{%v:lua.PaxLines.Workspace()%}"
    local reset = get_global_highlight()
    return "%-{%v:lua.PaxLines.Workspace()%}"
    --return string.format("%s%s%s", highlight, call, reset)
end

-- TODO
PaxLines.GitBranch = function()
    return "GitBranch"
end
local function GitBranch()
    local highlight = create_highlight("GitBranch")
    local call = "%-20{%v:lua.PaxLines.GitBranch()%}"
    local reset = get_global_highlight()
    return string.format("%s%s%s", highlight, call, reset)
end

-- TODO
PaxLines.GitProject = function()
    return "GitProject"
end
local function GitProject()
    local highlight = create_highlight("GitProject")
    local call = "%-10{%v:lua.PaxLines.GitProject()%}"
    local reset = get_global_highlight()
    return string.format("%s%s%s", highlight, call, reset)
end

PaxLines.Diagnostics = function()
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
    local no_client_attached = next(vim.lsp.buf_get_clients()) == nil
    if no_client_attached then
        return "[LSP]: Zzz"
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

    local icon = ""
    if vim.tbl_count(t) == 0 then
        return ("%s -"):format(icon)
    end
    return string.format("%s%s", icon, table.concat(t, ""))
end
local function Diagnostics()
    local highlight = create_highlight("Diagnostics")
    local call = "%-10{%v:lua.PaxLines.Diagnostics()%}"
    local reset = get_global_highlight()
    return string.format("%s%s%s", highlight, call, reset)
end

PaxLines.Mode = function()
    return PaxLines.mode.display_text
end
local function Mode()
    local call = "%{%v:lua.PaxLines.Mode()%}"
    return string.format("%s", call)
end

PaxLines.Search = function()
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

    return string.format("%s/%s", current, total)
end
local function Search()
    local highlight = create_highlight("Search")
    local call = "%-10{%v:lua.PaxLines.Search()%}"
    local reset = get_global_highlight()
    return string.format("%s%s%s", highlight, call, reset)
end

PaxLines.Location = function()
    return '%l:%-2{virtcol(".") - 1}'
end
local function Location()
    local highlight = create_highlight("Location")
    local call = "%-10{%v:lua.PaxLines.Location()%}"
    local reset = get_global_highlight()
    return string.format("%s%s%s", highlight, call, reset)
end

-- TODO
PaxLines.GitFile = function()
    return "GitFile"
end
local function GitFile()
    local highlight = create_highlight("GitFile")
    local call = "%-20{%v:lua.PaxLines.GitFile()%}"
    local reset = get_global_highlight()
    return string.format("%s%s%s", highlight, call, reset)
end

-- TODO
PaxLines.File = function()
    return "%m %f"
end
local function File()
    local highlight = create_highlight("File")
    local call = "%-20{%v:lua.PaxLines.File()%}"
    local reset = get_global_highlight()
    return "%m %f"
    --return string.format("%s%s%s", highlight, call, reset)
end
local function Spacer()
    return " "
end
local function Separator()
    return "%="
end

-- TODO make this actually work, for now use it to dummy the content for prototyping
local function get_terminal_width()
    return 168
end

-- TODO sort out active vs inactive windows, but this is great!
PaxLines.window = function()
    set_global_mode()
    return table.concat({
        get_global_highlight(),
        Workspace(),
        Separator(),
        Mode(),
        Separator(),
        File(),
    })
end

PaxLines.status = function()
    local current_width = get_terminal_width()
    local medium_breakpoint = 100
    local wide_breakpoint = 140

    set_global_mode()

    if current_width < medium_breakpoint then
        return table.concat({
            GitProject(),
            Spacer(),
            Diagnostics(),
            Separator(),
            Mode(),
            Separator(),
            Location(),
            Spacer(),
            Search(),
        })
    elseif current_width < wide_breakpoint then
        return table.concat({
            Workspace(),
            Spacer(),
            GitProject(),
            Spacer(),
            Diagnostics(),
            Separator(),
            Mode(),
            Separator(),
            Location(),
            Spacer(),
            Search(),
            Spacer(),
            File(),
        })
    else
        return table.concat({
            create_highlight(PaxLines.mode.hl_name),
            ModeRepeater(),
            Workspace(),
            Spacer(),
            GitBranch(),
            Spacer(),
            GitProject(),
            Spacer(),
            Diagnostics(),
            Separator(),
            Mode(),
            Separator(),
            Search(),
            Spacer(),
            Location(),
            Spacer(),
            GitFile(),
            Spacer(),
            File(),
            Spacer(),
            ModeRepeater(),
        })
    end
end

-- may become the autocmd from here
-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
--vim.opt.statusline = "%!v:lua.PaxLines.status()"
vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.opt.winbar = "%!v:lua.PaxLines.window()"
