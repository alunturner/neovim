return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")

            mason.setup()
            mason_lspconfig.setup({
                ensure_installed = {
                    "lua_ls",             -- Lua 
                    "tsserver",           -- Typescript and Javascript
                    "emmet_ls",           -- Emmet (Vue, HTML, CSS)
                    "cssls",              -- CSS
                    "rust_analyzer",      -- Rust
                    "eslint"              -- ESLint
                },
                automatic_installation = true
            });

            -- Individual lsp config can be added here
            mason_lspconfig.setup_handlers {
                function (server_name)
                    lspconfig[server_name].setup {}
                end,
                ["lua_ls"] = function ()
                    lspconfig.lua_ls.setup {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                }
                            }
                        }
                    }
                end,
            }
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('nvim-treesitter.configs').setup({

                -- Needed parsers
                ensure_installed = {
                    "lua",
                    "typescript",
                    "javascript",
                    "rust",
                    "vim",
                    "vimdoc"
                },

                -- Install all parsers synchronously
                sync_install = false,

                -- Подсветка
                highlight = {
                    -- Enabling highlight for all files
                    enable = true,
                    disable = {},
                },

                indent = {
                    -- Disabling indentation for all files
                    enable = false,
                    disable = {},
                }
            })
        end
    },
}