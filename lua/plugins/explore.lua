return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function ()
            require("neo-tree").setup({
                close_if_last_window = true,
                name = {
                    trailing_slash = true,
                    use_git_status_colors = true,
                    highlight = "NeoTreeFileName",
                },
                window = {
                    width = 40,
                },
                filesystem = {
                    follow_current_file = true,
                },
            })
        end
    }
}