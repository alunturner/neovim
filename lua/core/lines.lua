-- TODO
-- then add the sizing so that they look right in
-- wide
-- regular
-- narrow
PaxLines = {}
local hl_prefix = "PaxLines"
local function create_hl_string(hl_name)
    return string.format("#%s%s#", hl_prefix, hl_name)
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

PaxLines.ModeRepeater = function()
    local mode_code = vim.api.nvim_get_mode().mode
    local hl_name = modes[mode_code].hl_name

    local hl_string = create_hl_string(hl_name)
    local content = " "
    return string.format("%%%s%s", hl_string, content)
end
local function ModeRepeater()
    local call = "{%v:lua.PaxLines.ModeRepeater()%}"
    return string.format("%%%s", call)
end

PaxLines.Workspace = function()
    local workspace_path = vim.lsp.buf.list_workspace_folders()[1]
    local no_workspace = workspace_path == nil

    if no_workspace then
        return ""
    end

    -- clunky, but not sure how to do this cleanly
    local path_parts = {}
    for part in string.gmatch(workspace_path, "[^/]+") do
        table.insert(path_parts, part)
    end

    local hl_string = create_hl_string("Workspace")
    local content = path_parts[#path_parts]
    return string.format("%%%s%s", hl_string, content)
end
local function Workspace()
    local call = "{%v:lua.PaxLines.Workspace()%}"
    return string.format("%%%s", call)
end

-- TODO
PaxLines.GitBranch = function()
    local hl_string = create_hl_string("GitBranch")
    local content = "GitBranch"
    return string.format("%%%s%s", hl_string, content)
end
local function GitBranch()
    local call = "{%v:lua.PaxLines.GitBranch()%}"
    return string.format("%%%s", call)
end

-- TODO
PaxLines.GitProject = function()
    local hl_string = create_hl_string("GitProject")
    local content = "GitProject"
    return string.format("%%%s%s", hl_string, content)
end
local function GitProject()
    local call = "{%v:lua.PaxLines.GitProject()%}"
    return string.format("%%%s", call)
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

    local icon = ""
    if vim.tbl_count(t) == 0 then
        return ("%s -"):format(icon)
    end

    local hl_string = create_hl_string("Diagnostics")
    local content = string.format("%s%s", icon, table.concat(t, ""))
    return string.format("%%%s%s", hl_string, content)
end
local function Diagnostics()
    local call = "{%v:lua.PaxLines.Diagnostics()%}"
    return string.format("%%%s", call)
end

PaxLines.Mode = function()
    local mode_code = vim.api.nvim_get_mode().mode
    local hl_name = modes[mode_code].hl_name

    local hl_string = create_hl_string(hl_name)
    local content = modes[mode_code].display_text
    return string.format("%%%s%s", hl_string, content)
end
local function Mode()
    local call = "{%v:lua.PaxLines.Mode()%}"
    return string.format("%%%s", call)
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

    local hl_string = create_hl_string("Search")
    local content = string.format("%s/%s", current, total)
    return string.format("%%%s%s", hl_string, content)
end
local function Search()
    local call = "{%v:lua.PaxLines.Search()%}"
    return string.format("%%%s", call)
end

PaxLines.Location = function()
    local hl_string = create_hl_string("Location")
    local content = '%l:%-2{virtcol(".") - 1}'
    return string.format("%%%s%s", hl_string, content)
end
local function Location()
    local call = "{%v:lua.PaxLines.Location()%}"
    return string.format("%%%s", call)
end

-- TODO
PaxLines.GitFile = function()
    local hl_string = create_hl_string("GitFile")
    local content = "GitFile"
    return string.format("%%%s%s", hl_string, content)
end
local function GitFile()
    local call = "{%v:lua.PaxLines.GitFile()%}"
    return string.format("%%%s", call)
end

local function File()
    local hl_string = create_hl_string("File")
    local content = "%m %t"
    return string.format("%%%s%s", hl_string, content)
end
local function Spacer()
    local hl_string = create_hl_string("Spacer")
    local content = " "
    return string.format("%%%s%s", hl_string, content)
end
local function Separator()
    local hl_string = create_hl_string("Separator")
    local content = "%="
    return string.format("%%%s%s", hl_string, content)
end

-- TODO make this actually work, for now use it to dummy the content for prototyping
local function get_terminal_width()
    return 168
end

PaxLines.status = function()
    local current_width = get_terminal_width()
    local medium_breakpoint = 100
    local wide_breakpoint = 140

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
            ModeRepeater(),
            Spacer(),
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
vim.opt.statusline = "%!v:lua.PaxLines.status()"
