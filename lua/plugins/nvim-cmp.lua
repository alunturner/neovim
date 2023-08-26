local Plugin = {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        -- required
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        -- snippets
        "rafamadriz/friendly-snippets",
    },
}

Plugin.config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- add autopair integration to get brackets on methods/functions
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    require("luasnip/loaders/from_vscode").lazy_load()

    local kind_icons = {
        Text = "",
        Method = "m",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
    }

    cmp.setup({
        enabled = function()
            local context = require("cmp.config.context")
            -- disable completion in comments
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
        end,
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            ["<C-l>"] = cmp.mapping(function(fallback)
                if cmp.visible_docs() then
                    cmp.close_docs()
                else
                    cmp.open_docs()
                end
            end),
            ["<CR>"] = cmp.mapping.confirm({
                select = false,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.confirm({ select = true })
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                -- Kind icons
                vim_item.kind = string.format(" %s", kind_icons[vim_item.kind])
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip = "[Snippet]",
                })[entry.source.name]
                return vim_item
            end,
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "luasnip" },
        },
        matching = {
            disallow_fuzzy_matching = true,
        },
        view = {
            docs = {
                auto_open = false,
            },
        },
        window = {
            completion = cmp.config.window.bordered({
                scrollbar = true,
                winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
            }),
            documentation = cmp.config.window.bordered(),
        },
        experimental = {
            ghost_text = true,
        },
    })
end

return { Plugin }
