-- TODO: go over to minipairs: https://github.com/echasnovski/mini.pairs

local Plugin = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
}

Plugin.config = function()
    require("nvim-autopairs").setup({ map_cr = true })
end

return { Plugin }
