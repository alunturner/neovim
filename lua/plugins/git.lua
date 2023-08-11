--!structure: sets up git symbols in files and the file tree
--!uses: gitsigns::lewis6991/gitsigns.nvim

return {
    {
        'lewis6991/gitsigns.nvim',
        lazy = false,
        config = function()
            require('gitsigns').setup()
        end
    },
}
