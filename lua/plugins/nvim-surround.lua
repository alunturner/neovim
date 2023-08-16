--!structure::colour theme

local Plugin = {
     "kylechui/nvim-surround", --!uses::nvim-surround
    event = "VeryLazy",
}

    Plugin.config = function()
        require("nvim-surround").setup({
        })
    end

return { Plugin }
