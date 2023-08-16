--!structure::character pair matching

local Plugin = {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
}

Plugin.config = function()
    require("nvim-autopairs").setup({map_cr = true})
end

return { Plugin }
