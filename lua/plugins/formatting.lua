--!structure: per file type formatting rules
--!uses: formatter::mhartington/formatter.nvim_

local Plugin = {
    "mhartington/formatter.nvim",
    lazy = false,
}

Plugin.config = function()
    require("formatter").setup({
        filetype = {
            css = {
                require("formatter.filetypes.javascript").prettierd,
            },
            html = {
                require("formatter.filetypes.html").prettierd,
            },
            javascript = {
                require("formatter.filetypes.javascript").prettierd,
            },
            javascriptreact = {
                require("formatter.filetypes.javascriptreact").prettierd,
            },
            json = {
                require("formatter.filetypes.json").prettierd,
            },
            lua = {
                require("formatter.filetypes.lua").stylua,
            },
            markdown = {
                require("formatter.filetypes.markdown").prettierd,
            },
            rust = {
                require("formatter.filetypes.rust").rustfmt,
            },
            sh = {
                require("formatter.filetypes.sh").shfmt,
            },
            typescript = {
                require("formatter.filetypes.typescript").prettierd,
            },
            typescriptreact = {
                require("formatter.filetypes.typescriptreact").prettierd,
            },
            ["*"] = {
                require("formatter.filetypes.any").remove_trailing_whitespace,
            },
        },
    })

    local map = require("utils.keys").map

    map("n", "<leader>s", "<cmd>Format<CR>", "[s]tyle my buffer")
end

return { Plugin }
