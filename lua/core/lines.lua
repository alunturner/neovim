PaxLines = {}

PaxLines.active = function()
    return table.concat({
        "hello",
    })
end

vim.api.nvim_exec(
    [[
  augroup PaxLines
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.PaxLines.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.PaxLines.inactive()
  augroup END
]],
    false
)
