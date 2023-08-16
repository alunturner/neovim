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
    require("neo-tree").setup({
        sources = {
            "filesystem",
            "buffers",
            "git_status",
            "document_symbols",
        },
        default_component_configs = {
            name = {
                trailing_slash = true,
            },
        },
        window = {
            position = "float",
            popup = {
                size = {
                    height = "80%",
                    width = "50%",
                },
            },
            mappings = {
                ["l"] = "open",
                ["h"] = "close_node",
                ["<esc>"] = "cancel",
            },
        },
        filesystem = {
            window = {},
        },
        follow_current_file = true,
    })

    local map = require("utils.keys").map

    map("n", "<leader>e", "<cmd>Neotree reveal filesystem toggle<CR>", "show [e]xplorer")
    map("n", "<leader>g", "<cmd>Neotree git_status toggle<CR>", "show [g]it changes")
    map("n", "<leader>b", "<cmd>Neotree reveal buffers toggle<CR>", "show [b]uffers")
    map("n", "<leader>o", "<cmd>Neotree document_symbols toggle<CR>", "show [o]bjects")
end

return { Plugin }
