--!structure::language server protocols

local Plugin = {
    "neovim/nvim-lspconfig", --!uses::nvim-lsp-config
    dependencies = {
        -- this is the package manager for lsps and it's bridge to nvim-lspconfig
        { "williamboman/mason.nvim", config = true },
        "williamboman/mason-lspconfig.nvim",
        -- this is to allow easier setup for lua lsp
        "folke/neodev.nvim",
    },
}

Plugin.config = function()
    -- this gets run when an LSP connects to a particular buffer
    local on_attach = function(_, bufnr)
        local map = require("utils.keys").map

        map("n", "<F2>", vim.lsp.buf.rename, "VSCode style rename")
        map("n", "<Tab>", vim.lsp.buf.code_action, "Code action")
        map("n", "<F12>", vim.lsp.buf.definition, "VSCode style go to definition")
        map("n", "<leader><F12>", vim.lsp.buf.type_definition, "VSCode style go to type definition")
        map("n", "K", vim.lsp.buf.hover, "Hover")

        -- TODO see if this can be removed, do all formtting with the formatter to avoid ESLint vs Prettier problems
        --[[ Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
            vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
        --]]
    end

    -- this is used to define both the required servers and their initial configs
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

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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
