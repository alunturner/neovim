--!structure: git symbols
--!uses: gitsigns::lewis6991/gitsigns.nvim

local Plugin = {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    config = function()
    end
}

Plugin.config = function ()
    require('gitsigns').setup()
end

return { Plugin }
