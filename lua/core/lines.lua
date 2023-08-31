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

PaxLines.mode_repeater = function()
    local mode_code = vim.api.nvim_get_mode().mode
    local hl_name = modes[mode_code].hl_name
    local hl_string = create_hl_string(hl_name)

    return string.format("%%%s%s", hl_string, "  ")
end
local function mode_repeater()
    local call = "{%v:lua.PaxLines.mode_repeater()%}"
    return string.format("%%%s", call)
end

PaxLines.workspace = function()
    return "WORKSPACE"
end
local function workspace()
    local call = "{%v:lua.PaxLines.workspace()%}"
    return string.format("%%%s", call)
end

PaxLines.git_branch = function()
    return "GIT_BRANCH"
end
local function git_branch()
    local call = "{%v:lua.PaxLines.git_branch()%}"
    return string.format("%%%s", call)
end

PaxLines.git_project = function()
    return "FN_PROJECT"
end
local function git_project()
    local call = "{%v:lua.PaxLines.git_project()%}"
    return string.format("%%%s", call)
end

PaxLines.diagnostics = function()
    return "DIAGNOSTICS"
end
local function diagnostics()
    local call = "{%v:lua.PaxLines.diagnostics()%}"
    return string.format("%%%s", call)
end

PaxLines.mode = function()
    return "mode"
end
local function mode()
    local call = "{%v:lua.PaxLines.mode()%}"
    return string.format("%%%s", call)
end

PaxLines.search = function()
    return "search"
end
local function search()
    local call = "{%v:lua.PaxLines.search()%}"
    return string.format("%%%s", call)
end

PaxLines.location = function()
    return "location"
end
local function location()
    local call = "{%v:lua.PaxLines.location()%}"
    return string.format("%%%s", call)
end

PaxLines.git_file = function()
    return "git_file"
end
local function git_file()
    local call = "{%v:lua.PaxLines.git_file()%}"
    return string.format("%%%s", call)
end

local function file()
    local content = "%m %t"
    return string.format("%s", content)
end

local function separator()
    local content = "%="
    return string.format("%s", content)
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
        return table.concat(
            { git_project(), diagnostics(), separator(), mode(), separator(), location(), search() },
            " "
        )
    elseif current_width < wide_breakpoint then
        return table.concat({
            workspace(),
            git_project(),
            diagnostics(),
            separator(),
            mode(),
            separator(),
            location(),
            search(),
            file(),
        }, " ")
    else
        return table.concat({
            mode_repeater(),
            workspace(),
            git_branch(),
            git_project(),
            diagnostics(),
            separator(),
            mode(),
            separator(),
            location(),
            search(),
            git_file(),
            file(),
            mode_repeater(),
        }, " ")
    end
end

-- may become the autocmd from here
-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
vim.opt.statusline = "%!v:lua.PaxLines.status()"
