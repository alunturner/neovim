PaxLines = {}

PaxLines.git_project = function()
    return "FN_PROJECT"
end
local function git_project()
    local call = "{%v:lua.PaxLines.git_project()%}"
    local width = "10"
    return string.format("%%%s%s", width, call)
end

PaxLines.diagnostics = function()
    return "DIAGNOSTICS"
end
local function diagnostics()
    local call = "{%v:lua.PaxLines.diagnostics()%}"
    local width = "10"
    return string.format("%%%s%s", width, call)
end

PaxLines.mode = function()
    return "mode"
end
local function mode()
    local call = "{%v:lua.PaxLines.mode()%}"
    local width = "40"
    return string.format("%%%s%s", width, call)
end

PaxLines.search = function()
    return "search"
end
local function search()
    local call = "{%v:lua.PaxLines.search()%}"
    local width = "10"
    return string.format("%%%s%s", width, call)
end

PaxLines.location = function()
    return "location"
end
local function location()
    local call = "{%v:lua.PaxLines.location()%}"
    local width = "10"
    return string.format("%%%s%s", width, call)
end

PaxLines.git_file = function()
    return "git_file"
end
local function git_file()
    local call = "{%v:lua.PaxLines.git_file()%}"
    local width = "20"
    return string.format("%%%s%s", width, call)
end

local function file()
    local content = "%m %t"
    return string.format("%s", content)
end

PaxLines.status = function()
    return table.concat({
        git_project(),
        diagnostics(),
        mode(),
        location(),
        search(),
        git_file(),
        file(),
    }, " ")
end

-- may become the autocmd from here
-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
vim.opt.statusline = "%!v:lua.PaxLines.status()"
