--!structure: per file type formatting rules
--!uses: formatter::mhartington/formatter.nvim_

local Plugin = {
    "mhartington/formatter.nvim",
    lazy = false,
}

Plugin.config = function()
    require("formatter").setup({
        filetype = {
            lua = {
                require("formatter.filetypes.lua").stylua,
            },
            ["*"] = {
                require("formatter.filetypes.any").remove_trailing_whitespace
            }
        }
    })

    local map = require("utils.keys").map

    map('n', '<leader>s', '<cmd>Format<CR>', '[s]tyle my buffer')
end

return { Plugin }
