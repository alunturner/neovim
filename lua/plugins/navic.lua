--!structure::to allow breadcrumb view in windowline

local Plugin = {
    "SmiteshP/nvim-navic", --!uses::navic
    dependencies = { "neovim/nvim-lspconfig" },
    lazy = false,
}

Plugin.config = function()
    require("nvim-navic").setup({
        lsp = {
            auto_attach = true
        }
    })
end

return { Plugin }

