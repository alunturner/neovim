--!structure::better highlighting and navigation

local Plugin = {
    "nvim-treesitter/nvim-treesitter", --!uses::treesitter
    lazy = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
}

Plugin.config = function()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "css",
            "javascript",
            "lua",
            "rust",
            "typescript",
            "tsx",
            "vim",
            "vimdoc",
        },
        sync_install = false,
        auto_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["ap"] = "@parameter.outer",
                    ["ip"] = "@parameter.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]f"] = "@function.outer",
                    ["]c"] = "@class.outer",
                },
                goto_next_end = {
                    ["]F"] = "@function.outer",
                    ["]C"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[c"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    ["[C"] = "@class.outer",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>p"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>P"] = "@parameter.inner",
                },
            },
        },
    })
end

return { Plugin }
