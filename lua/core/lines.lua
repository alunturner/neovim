PaxLines = {}
local prefix = "PaxLines"
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

local function get_current_mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return modes[current_mode]
end

-- util function to create a highlight string
local function create_highlight(highlight)
    return string.format("%%#%s%s#", prefix, highlight)
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
    return " %-10{%v:lua.PaxLines.Search()%}"
end

local function ModifiedAndFile()
    return "%-m %-f"
end

local function Separator()
    return "%="
end

PaxLines.winbar = function()
    local mode = get_current_mode()

    return table.concat({
        create_highlight(mode.hl_name),
        mode.display_text,
        Separator(),
        Search(),
        Separator(),
        ModifiedAndFile(),
    })
end

-- ref: https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
vim.opt.winbar = "%!v:lua.PaxLines.winbar()"
