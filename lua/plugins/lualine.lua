--!structure::add status line

-- try and smash in a local arctic theme
local colors = {
  pink = '#c586c0',
  red = '#c72e0f',
  orange = '#cc6633',
  green = '#16825d',
  blue = '#007acc',
  violet = '#646695',
  purple = '#68217a',
  white = '#ffffff',
  lightgray = '#454545',
  gray = '#252526',
}

local custom_arctic = {
  normal = {
    a = { fg = colors.white, bg = colors.blue },
    b = { fg = colors.white, bg = colors.lightgray },
    c = { fg = colors.white, bg = colors.gray }
  },
  insert = {
    a = { fg = colors.white, bg = colors.orange },
  },
  visual = {
    a = { fg = colors.white, bg = colors.purple },
  },
  replace = {
    a = { fg = colors.white, bg = colors.pink },
  },
  command = {
    a = { fg = colors.white, bg = colors.green },
  },
  terminal = {
    a = { fg = colors.white, bg = colors.violet },
  },
  pending = {
    a = { fg = colors.white, bg = colors.red },
  },
  inactive = {
    a = { fg = colors.white, bg = colors.darkgray },
  }
}

local Plugin = {
    "nvim-lualine/lualine.nvim", --!uses::lualine
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
}

Plugin.config = function()
    require("lualine").setup({
        options = {
            theme = custom_arctic,
            disabled_filetypes = {
                statusline = {"no-neck-pain"}
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
