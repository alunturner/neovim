-- theme taken from the below, see core.theme file for more details
-- Copyright (c) 2020-2021 Mofiqul Islam
-- MIT license, see LICENSE for more details.
-- not an error! need to have required the core.theme to make sure lualine
-- displays properly
require("core.theme")
local dark_plus = {}
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

dark_plus.normal = {
    a = { fg = colors.fg, bg = colors.blue, gui = "bold" },
    b = { fg = colors.blue, bg = colors.bg2 },
    c = { fg = colors.fg, bg = colors.bg },
}

dark_plus.visual = {
    a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
    b = { fg = colors.yellow, bg = colors.bg },
}

dark_plus.inactive = {
    a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
    b = { fg = colors.inactive, bg = colors.bg },
    c = { fg = colors.inactive, bg = colors.bg },
}

dark_plus.replace = {
    a = { fg = colors.bg, bg = colors.red, gui = "bold" },
    b = { fg = colors.red, bg = colors.bg2 },
    c = { fg = colors.fg, bg = colors.bg },
}

dark_plus.insert = {
    a = { fg = colors.bg, bg = colors.green, gui = "bold" },
    b = { fg = colors.green, bg = colors.bg2 },
    c = { fg = colors.fg, bg = colors.bg },
}

dark_plus.terminal = {
    a = { fg = colors.bg, bg = colors.green, gui = "bold" },
    b = { fg = colors.fg, bg = colors.bg2 },
    c = { fg = colors.fg, bg = colors.bg },
}

dark_plus.command = {
    a = { fg = colors.bg, bg = colors.pink, gui = "bold" },
    b = { fg = colors.pink, bg = colors.bg2 },
    c = { fg = colors.fg, bg = colors.bg },
}

local Plugin = {
    "nvim-lualine/lualine.nvim", --!uses::lualine
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
}

Plugin.config = function()
    require("lualine").setup({
        options = {
            theme = dark_plus,
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
