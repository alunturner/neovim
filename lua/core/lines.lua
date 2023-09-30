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

PaxLines.active = function()
    local current_mode = get_current_mode()
    -- use the highlight for the whole bar
    local highlight = string.format("%%#%s%s#", prefix, current_mode.hl_name)
    -- add a leading space to the mode
    local display_mode = " " .. current_mode.display_text

    return table.concat({
        highlight,
        display_mode,
        "%=", -- separator for left/right sections
        "%m %f ", -- modified indicator plus filename with post space
    })
end

vim.opt.statusline = "%!v:lua.PaxLines.active()"
