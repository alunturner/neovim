--!structure: sets up the lsps 
--!uses: mason::williamboman/mason.nvim, treesitter::nvim-treesitter/nvim-treesitter"

return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup()

            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup({
                ensure_installed = {
                    "lua_ls",
                    "tsserver",
                    "emmet_ls",
                    "cssls",
                    "rust_analyzer",
                    "eslint"},
                    automatic_installation = true
            });

            -- Individual lsp config can be added here
            local lspconfig = require("lspconfig")
            mason_lspconfig.setup_handlers({
                function (server_name)
                    lspconfig[server_name].setup {}
                end,
                ["lua_ls"] = function ()
                    lspconfig.lua_ls.setup({
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                }
                            }
                        }
                    })
                end,
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "css",
                    "lua",
                    "typescript",
                    "javascript",
                    "rust",
                    "vim",
                    "vimdoc"
                },
                sync_install = false,
                highlight = {
                    enable = true,
                    disable = {},
                },
                indent = {
                    enable = false,
                    disable = {},
                }
            })
        end
    },
}