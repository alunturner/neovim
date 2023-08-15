--!structure::add status line

local Plugin = {
    'nvim-lualine/lualine.nvim', --!uses::lualine
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }}

Plugin.config = function()
    require("lualine").setup()
end

return { Plugin }
