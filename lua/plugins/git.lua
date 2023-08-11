--!structure: sets up git symbols in files and the file tree
--!uses: gitsigns::lewis6991/gitsigns.nvim

return {
    {
        'lewis6991/gitsigns.nvim',
        lazy = false,
        config = function()
            require('gitsigns').setup({
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'right_align',
                    delay = 1000,
                    ignore_whitespace = false,
                },
            })
        end
    },
}
