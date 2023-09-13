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
    local call = "%{%v:lua.PaxLines.Workspace()%}"
    local reset = get_global_highlight()
    return string.format("%s%s%s ", highlight, call, reset)
end

-- TODO
PaxLines.GitBranch = function()
    return " GitBranch"
end
local function GitBranch()
    local highlight = create_highlight("GitBranch")
    local call = "%{%v:lua.PaxLines.GitBranch()%}"
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

PaxLines.File = function()
    return "%m %f"
end
local function File()
    local highlight = create_highlight("File")
    local call = "%-20{%v:lua.PaxLines.File()%}"
    local reset = get_global_highlight()
    return string.format("%s%s%s", highlight, call, reset)
end

local function Separator()
    return "%="
end

local function RightChevron()
    return ""
end

PaxLines.active = function()
    set_global_mode()
    return table.concat({
        get_global_highlight(),
        Workspace(),
        RightChevron(),
        GitBranch(),
        Separator(),
        Mode(),
        Search(),
        Separator(),
        File(),
    })
end

PaxLines.inactive = function()
    return table.concat({
        Separator(),
        File(),
    })
end

-- ref: https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
vim.opt.statusline = "%!v:lua.PaxLines.active()"
