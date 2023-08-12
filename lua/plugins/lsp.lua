--!structure: lsp and treesitter 
--!uses: lsp-zero::VonHeikemen/lsp-zero.nvim, treesitter::nvim-treesitter/nvim-treesitter"

local Lsp = {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},             -- Required
        {'williamboman/mason.nvim'},           -- Optional
        {'williamboman/mason-lspconfig.nvim'}, -- Optional

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
    },
}

local Treesitter = {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
}

Lsp.config = function ()
    local lsp = require('lsp-zero').preset({})

    lsp.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp.default_keymaps({buffer = bufnr})
    end)

    -- (Optional) Configure lua language server for neovim
    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

    lsp.setup()
end


Treesitter.config = function ()
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
        indent = {
            enable = true,
        }
    })
end

return { Lsp, Treesitter }
