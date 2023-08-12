--!structure: lsp and treesitter
--!uses: lsp-zero::VonHeikemen/lsp-zero.nvim, treesitter::nvim-treesitter/nvim-treesitter"

local Lsp = {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
        -- LSP Support
        { 'neovim/nvim-lspconfig' },             -- Required
        { 'williamboman/mason.nvim' },           -- Optional
        { 'williamboman/mason-lspconfig.nvim' }, -- Optional

        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },     -- Required
        { 'hrsh7th/cmp-nvim-lsp' }, -- Required
        { 'L3MON4D3/LuaSnip' },     -- Required
    },
}

local Treesitter = {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
}

Lsp.config = function()
    local lsp = require('lsp-zero').preset({})

    lsp.ensure_installed({
        "tsserver",
        "rust_analyzer",
        "lua_ls",
        "eslint",
        "emmet_ls",
        "cssls",
        "html",
        "jsonls",
        "marksman",
    })

    lsp.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp.default_keymaps({ buffer = bufnr })
    end)

    -- Configure lua language server for neovim
    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

    lsp.setup()

    -- Setup cmp after lsp-zero
    local cmp = require("cmp")

    cmp.setup({
        mapping = {
            ["<C-Space>"] = cmp.mapping.confirm({ select = false }),
            ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        }
    })
end


Treesitter.config = function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            "css",
            "lua",
            "typescript",
            "javascript",
            "rust",
            "vim",
            "vimdoc"
        },
        sync_install = false,
        auto_install = false,
        highlight = {
            enable = true,
            disable = {}, -- TODO disable TS/Rust if required
            additional_vim_regex_highlighting = false,

        },
    })
end

return { Lsp, Treesitter }
