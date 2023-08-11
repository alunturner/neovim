return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup()
        end
    },
}
