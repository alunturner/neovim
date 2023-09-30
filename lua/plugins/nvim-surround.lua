-- TODO go across to mini surround: https://github.com/echasnovski/mini.surround

local Plugin = {
    "kylechui/nvim-surround",
    event = "VeryLazy",
}

Plugin.config = function()
    require("nvim-surround").setup({})
end

return { Plugin }
