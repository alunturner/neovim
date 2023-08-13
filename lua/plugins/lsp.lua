--!structure: language server protocols
--!uses: nvim-lspconfig::neovim/nvim-lspconfig

local Plugin = {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim", config = true },
        "williamboman/mason-lspconfig.nvim",
        "folke/neodev.nvim",
    },
}

Plugin.config = function()
    local on_attach = function(_, bufnr)
        local map = require("utils.keys").map

        map({ "n", "i", "v" }, "<F2>", vim.lsp.buf.rename, "VSCode style rename")
        map("n", "<Tab>", vim.lsp.buf.code_action, "Code action")
        map({ "n", "i", "v" }, "<F12>", vim.lsp.buf.definition, "VSCode style go to definition")
        map({ "n", "i", "v" }, "<leader><F12>", vim.lsp.buf.type_definition, "VSCode style go to type definition")
        map("n", "K", vim.lsp.buf.hover, "Hover")

        -- TODO see if this can be removed, do all formtting with the formatter to avoid ESLint vs Prettier problems
        --[[ Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
            vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
        --]]
    end

    -- this is used to define both the required servers and their initial config
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

    -- Ensure the servers above are installed
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
