--!structure::available completion options

local Plugin = {
    "hrsh7th/nvim-cmp", --!uses::nvim-cmp
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        -- Sources for the command line and search
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",

        -- Source for lsp output
        "hrsh7th/cmp-nvim-lsp",
    },
}

Plugin.config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- configure autocomplete for lua, I think this is required for more than just lua
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({})

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        -- add basic mappings for position control and auto insertion of first item on <Tab>
        mapping = cmp.mapping.preset.insert({
            ["<C-j>"] = cmp.mapping.select_next_item(),
            ["<C-k>"] = cmp.mapping.select_prev_item(),
            ["<Tab>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
        }),
        -- in a document, allow lsp and path candidates
        sources = {
            { name = "nvim_lsp" },
        },
    })

    -- in the command line, allow path and command line candidates
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
    })

    -- in the search bar, allow buffer candidates
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })
end

return { Plugin }
