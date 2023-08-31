-- theme taken from the below, see core.theme file for more details
-- Copyright (c) 2020-2021 Mofiqul Islam
-- MIT license, see LICENSE for more details.
-- not an error! need to have required the core.theme to make sure lualine
-- displays properly, we can sort the ordering of this when we bring the
-- status line design in house
require("core.theme")
local pax = {}
local colors = {
    inactive = "#666666",
    bg = "#262626",
    bg2 = "#373737",
    fg = "#ffffff",
    red = "#f44747",
    green = "#4EC9B0",
    blue = "#0a7aca",
    lightblue = "#5CB6F8",
    yellow = "#ffaf00",
    pink = "#DDB6F2",
}

pax.normal = {
    a = { fg = colors.fg, bg = colors.blue, gui = "bold" },
    b = { fg = colors.blue, bg = colors.bg2 },
    c = { fg = colors.fg, bg = colors.bg },
}

pax.visual = {
    a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
    b = { fg = colors.yellow, bg = colors.bg },
}

pax.inactive = {
    a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
    b = { fg = colors.inactive, bg = colors.bg },
    c = { fg = colors.inactive, bg = colors.bg },
}

pax.replace = {
    a = { fg = colors.bg, bg = colors.red, gui = "bold" },
    b = { fg = colors.red, bg = colors.bg2 },
    c = { fg = colors.fg, bg = colors.bg },
}

pax.insert = {
    a = { fg = colors.bg, bg = colors.green, gui = "bold" },
    b = { fg = colors.green, bg = colors.bg2 },
    c = { fg = colors.fg, bg = colors.bg },
}

pax.terminal = {
    a = { fg = colors.bg, bg = colors.green, gui = "bold" },
    b = { fg = colors.fg, bg = colors.bg2 },
    c = { fg = colors.fg, bg = colors.bg },
}

pax.command = {
    a = { fg = colors.bg, bg = colors.pink, gui = "bold" },
    b = { fg = colors.pink, bg = colors.bg2 },
    c = { fg = colors.fg, bg = colors.bg },
}

local Plugin = {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    enabled = false,
}

Plugin.config = function()
    require("lualine").setup({
        options = {
            theme = pax,
            disabled_filetypes = {
                statusline = { "no-neck-pain" },
            },
        },
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
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = { "filename" },
            lualine_z = { "mode" },
        },
    })
end

return { Plugin }
