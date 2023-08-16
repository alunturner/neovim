--!structure::add status line

local Plugin = {
    "nvim-lualine/lualine.nvim", --!uses::lualine
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
}

Plugin.config = function()
    require("lualine").setup({
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "diagnostics" },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { "location" },
            lualine_z = { "mode" },
        },
        winbar = {
            lualine_a = { "mode" },
            lualine_b = { },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { "filename" },
            lualine_z = { "mode" }
        }
    })
end

return { Plugin }
