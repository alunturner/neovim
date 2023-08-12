--!structure: git symbols
--!uses: gitsigns::lewis6991/gitsigns.nvim

local Plugin = {
    'lewis6991/gitsigns.nvim',
    lazy = false,
}

Plugin.config = function ()
    require('gitsigns').setup({
        current_line_blame_opts = {
            -- do not need a delay as will toggle manually
            delay = 0,
            virt_text_pos = "right_align"
        }
    })

    local map = require("utils.keys").map

    map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle [g]it [b]lame")
end

return { Plugin }
