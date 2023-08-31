PaxLines = {}

PaxLines.status = function()
    return table.concat({
        "hello",
    }, " ")
end

-- may become the autocmd from here
-- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
vim.opt.statusline = "%!v:lua.PaxLines.status()"
