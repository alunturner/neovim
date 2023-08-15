return {
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- formatters
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.formatting.shfmt,
                    null_ls.builtins.formatting.rustfmt,

                    -- diagnostics 
                    null_ls.builtins.diagnostics.eslint_d,
                },
            })
        end,
    },
}
