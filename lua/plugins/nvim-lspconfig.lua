--!structure::language server protocols

local Plugin = {
    "neovim/nvim-lspconfig", --!uses::nvim-lsp-config
    dependencies = {
        -- package manager for lsps
        { "williamboman/mason.nvim", config = true },
        -- bridge mason to nvim-lspconfig
        "williamboman/mason-lspconfig.nvim",
        -- allow easier setup for lua lsp
        "folke/neodev.nvim",
    },
}

Plugin.config = function()
    -- this gets run when an LSP connects to a particular buffer
    local on_attach = function(client, bufnr)
        local map = require("utils.keys").map

        map("n", "<leader>f", vim.lsp.buf.format, "[f]ormat the file")
        map("n", "<F2>", vim.lsp.buf.rename, "VSCode style rename")
        map("n", "<Tab>", vim.lsp.buf.code_action, "Code action")
        map("n", "<F12>", vim.lsp.buf.definition, "VSCode style go to definition")
        map("n", "<leader><F12>", vim.lsp.buf.type_definition, "VSCode style go to type definition")
        map("n", "K", vim.lsp.buf.hover, "Hover")
    end

    -- define required servers and their initial configs
    local servers = {
        rust_analyzer = {},
        tsserver = {},
        html = { filetypes = { "html" } },
        lua_ls = {
            Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    }

    -- setup neovim lua configuration
    require("neodev").setup()

    -- get the capabilities for handler setup
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- ensure the servers above are installed
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
    })

    mason_lspconfig.setup_handlers({
        function(server_name)
            require("lspconfig")[server_name].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = servers[server_name],
                filetypes = (servers[server_name] or {}).filetypes,
            })
        end,
    })
end

return { Plugin }
