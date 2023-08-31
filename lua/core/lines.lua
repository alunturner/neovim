PaxLines = {}

PaxLines.git_project = function()
    return "FN_PROJECT"
end
local function git_project()
    local call = "{%v:lua.PaxLines.git_project()%}"
    local width = "30"
    return string.format("%%%s%s", width, call)
end

PaxLines.status = function()
    return table.concat({
        git_project(),
        "hello",
    }, " ")
end

-- may become the autocmd from here
-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
vim.opt.statusline = "%!v:lua.PaxLines.status()"
