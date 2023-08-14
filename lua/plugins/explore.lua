--!structure::file tree

local Plugin = {
    "nvim-neo-tree/neo-tree.nvim", --!uses::neo-tree
    branch = "v2.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
}

Plugin.config = function()
    require("neo-tree").setup()

    local map = require("utils.keys").map

    map({ "n", "v" }, "<leader>e", "<cmd>Neotree focus toggle<CR>", "show [e]xplorer")
end

return { Plugin }
