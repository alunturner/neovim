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
                    -- nb can disable by filetype by using:
                    -- null_ls.<formatter>.with({disabled_filetypes = { "type" }})
                    -- language specific formatters
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.formatting.shfmt,
                    null_ls.builtins.formatting.rustfmt,

                    -- general use formatters
                    null_ls.builtins.formatting.trim_newlines,
                    null_ls.builtins.formatting.trim_whitespace,

                    -- diagnostics
                    null_ls.builtins.diagnostics.eslint_d,
                },
            })
        end,
    },
}
