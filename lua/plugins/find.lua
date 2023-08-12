--!structure: fuzzy finder
--!uses: telescope::nvim-telescope/telescope.nvim

local Plugin = {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
}

Plugin.config = function ()
    require("telescope").setup()
end

return { Plugin }
