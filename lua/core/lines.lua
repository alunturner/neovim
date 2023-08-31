PaxLines = {}

PaxLines.mode_repeater = function()
    return "M"
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
