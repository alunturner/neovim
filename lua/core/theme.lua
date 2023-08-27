-- vscode.nvim color scheme
-- Lua port of https://github.com/tomasiser/vim-code-dark
-- By http://github.com/mofiqul
-- shamelessly pillaged from https://github.com/Mofiqul/vscode.nvim/tree/main

-- tidy up how we handle the strings for dark and light
local DARK = "dark"
local LIGHT = "light"

vim.o.background = DARK
local isDark = vim.o.background == LIGHT

-- hacky way to get the config into lualine - this can go when config goes
local M = {}

-- colors used to set highlights inside theme.set_highlights function
-- this is no longer set by a function, we simply have an object that is set depending on
-- the value of vim.o.background (default dark)
local colors = {}

-- colors that vary by theme
if isDark then
    colors = {
        vscNone = "NONE",
        vscFront = "#D4D4D4",
        vscBack = "#1E1E1E",

        vscTabCurrent = "#1E1E1E",
        vscTabOther = "#2D2D2D",
        vscTabOutside = "#252526",

        vscLeftDark = "#252526",
        vscLeftMid = "#373737",
        vscLeftLight = "#636369",

        vscPopupFront = "#BBBBBB",
        vscPopupBack = "#272727",
        vscPopupHighlightBlue = "#004b72",
        vscPopupHighlightGray = "#343B41",

        vscSplitLight = "#898989",
        vscSplitDark = "#444444",
        vscSplitThumb = "#424242",

        vscCursorDarkDark = "#222222",
        vscCursorDark = "#51504F",
        vscCursorLight = "#AEAFAD",
        vscSelection = "#264F78",
        vscLineNumber = "#5A5A5A",

        vscDiffRedDark = "#4B1818",
        vscDiffRedLight = "#6F1313",
        vscDiffRedLightLight = "#FB0101",
        vscDiffGreenDark = "#373D29",
        vscDiffGreenLight = "#4B5632",
        vscSearchCurrent = "#515c6a",
        vscSearch = "#613315",

        vscGitAdded = "#81b88b",
        vscGitModified = "#e2c08d",
        vscGitDeleted = "#c74e39",
        vscGitRenamed = "#73c991",
        vscGitUntracked = "#73c991",
        vscGitIgnored = "#8c8c8c",
        vscGitStageModified = "#e2c08d",
        vscGitStageDeleted = "#c74e39",
        vscGitConflicting = "#e4676b",
        vscGitSubmodule = "#8db9e2",

        vscContext = "#404040",
        vscContextCurrent = "#707070",

        vscFoldBackground = "#202d39",

        -- Syntax colors
        vscGray = "#808080",
        vscViolet = "#646695",
        vscBlue = "#569CD6",
        vscAccentBlue = "#4FC1FE",
        vscDarkBlue = "#223E55",
        vscMediumBlue = "#18a2fe",
        vscLightBlue = "#9CDCFE",
        vscGreen = "#6A9955",
        vscBlueGreen = "#4EC9B0",
        vscLightGreen = "#B5CEA8",
        vscRed = "#F44747",
        vscOrange = "#CE9178",
        vscLightRed = "#D16969",
        vscYellowOrange = "#D7BA7D",
        vscYellow = "#DCDCAA",
        vscDarkYellow = "#FFD602",
        vscPink = "#C586C0",
    }
else
    colors = {
        vscNone = "NONE",
        vscFront = "#343434",
        vscBack = "#FFFFFF",

        vscTabCurrent = "#FFFFFF",
        vscTabOther = "#CECECE",
        vscTabOutside = "#E8E8E8",

        vscLeftDark = "#F3F3F3",
        vscLeftMid = "#E5E5E5",
        vscLeftLight = "#F3F3F3",

        vscPopupFront = "#000000",
        vscPopupBack = "#F3F3F3",
        vscPopupHighlightBlue = "#0064c1",
        vscPopupHighlightGray = "#767676",

        vscSplitLight = "#EEEEEE",
        vscSplitDark = "#DDDDDD",
        vscSplitThumb = "#DFDFDF",

        vscCursorDarkDark = "#E5EBF1",
        vscCursorDark = "#6F6F6F",
        vscCursorLight = "#767676",
        vscSelection = "#ADD6FF",
        vscLineNumber = "#098658",

        vscDiffRedDark = "#FFCCCC",
        vscDiffRedLight = "#FFA3A3",
        vscDiffRedLightLight = "#FFCCCC",
        vscDiffGreenDark = "#DBE6C2",
        vscDiffGreenLight = "#EBF1DD",
        vscSearchCurrent = "#A8AC94",
        vscSearch = "#F8C9AB",

        vscGitAdded = "#587c0c",
        vscGitModified = "#895503",
        vscGitDeleted = "#ad0707",
        vscGitRenamed = "#007100",
        vscGitUntracked = "#007100",
        vscGitIgnored = "#8e8e90",
        vscGitStageModified = "#895503",
        vscGitStageDeleted = "#ad0707",
        vscGitConflicting = "#ad0707",
        vscGitSubmodule = "#1258a7",

        vscContext = "#D2D2D2",
        vscContextCurrent = "#929292",

        vscFoldBackground = "#e6f3ff",

        -- Syntax colors
        vscGray = "#000000",
        vscViolet = "#000080",
        vscBlue = "#0000FF",
        vscDarkBlue = "#007ACC",
        vscLightBlue = "#0451A5",
        vscGreen = "#008000",
        vscBlueGreen = "#16825D",
        vscLightGreen = "#098658",
        vscRed = "#FF0000",
        vscOrange = "#C72E0F",
        vscLightRed = "#A31515",
        vscYellowOrange = "#800000",
        vscYellow = "#795E26",
        vscPink = "#AF00DB",
    }
end

-- colors that do not vary by theme
colors.vscUiBlue = "#084671"
colors.vscUiOrange = "#f28b25"
colors.vscPopupHighlightLightBlue = "#d7eafe"

-- this part of the file represents the equivalent of the setup steps in the readme,
-- but it replaces any "require" calls with the actual code it was requiring in
local vscode = {}
local config = {} -- nb this is required in the lualine theme file

-- initialize the config to the defaults
config.opts = {
    transparent = false,
    italic_comments = false,
    color_overrides = {},
    group_overrides = {},
    disable_nvimtree_bg = true,
}

-- setting transparent to true removes the default background
if config.opts.transparent then
    config.opts.color_overrides.vscBack = "NONE"
end

local hl = vim.api.nvim_set_hl
local theme = {}

-- this is where we set the highlight groups for neovim and it's installed plugins
theme.set_highlights = function(opts)
    local c = colors
    local isDark = vim.o.background == "dark"

    hl(0, "Normal", { fg = c.vscFront, bg = c.vscBack })
    hl(0, "ColorColumn", { fg = "NONE", bg = c.vscCursorDarkDark })
    hl(0, "Cursor", { fg = c.vscCursorDark, bg = c.vscCursorLight })
    hl(0, "CursorLine", { bg = c.vscCursorDarkDark })
    hl(0, "CursorColumn", { fg = "NONE", bg = c.vscCursorDarkDark })
    hl(0, "Directory", { fg = c.vscBlue, bg = c.vscBack })
    hl(0, "DiffAdd", { fg = "NONE", bg = c.vscDiffGreenLight })
    hl(0, "DiffChange", { fg = "NONE", bg = c.vscDiffRedDark })
    hl(0, "DiffDelete", { fg = "NONE", bg = c.vscDiffRedLight })
    hl(0, "DiffText", { fg = "NONE", bg = c.vscDiffRedLight })
    hl(0, "EndOfBuffer", { fg = c.vscBack, bg = "NONE" })
    hl(0, "ErrorMsg", { fg = c.vscRed, bg = c.vscBack })
    hl(0, "VertSplit", { fg = c.vscSplitDark, bg = c.vscBack })
    hl(0, "Folded", { fg = "NONE", bg = c.vscFoldBackground })
    hl(0, "FoldColumn", { fg = c.vscLineNumber, bg = c.vscBack })
    hl(0, "SignColumn", { fg = "NONE", bg = c.vscBack })
    hl(0, "IncSearch", { fg = c.vscNone, bg = c.vscSearchCurrent })
    hl(0, "LineNr", { fg = c.vscLineNumber, bg = c.vscBack })
    hl(0, "CursorLineNr", { fg = c.vscPopupFront, bg = c.vscBack })
    hl(0, "MatchParen", { fg = c.vscNone, bg = c.vscCursorDark })
    hl(0, "ModeMsg", { fg = c.vscFront, bg = c.vscLeftDark })
    hl(0, "MoreMsg", { fg = c.vscFront, bg = c.vscLeftDark })
    hl(0, "NonText", { fg = (isDark and c.vscLineNumber or c.vscTabOther), bg = c.vscNone })
    hl(0, "Pmenu", { fg = c.vscPopupFront, bg = c.vscPopupBack })
    hl(0, "PmenuSel", { fg = isDark and c.vscPopupFront or c.vscBack, bg = c.vscPopupHighlightBlue })
    hl(0, "PmenuSbar", { fg = "NONE", bg = c.vscPopupHighlightGray })
    hl(0, "PmenuThumb", { fg = "NONE", bg = c.vscPopupFront })
    hl(0, "Question", { fg = c.vscBlue, bg = c.vscBack })
    hl(0, "Search", { fg = c.vscNone, bg = c.vscSearch })
    hl(0, "SpecialKey", { fg = c.vscBlue, bg = c.vscNone })
    hl(0, "StatusLine", { fg = c.vscFront, bg = c.vscLeftMid })
    hl(0, "StatusLineNC", { fg = c.vscFront, bg = opts.transparent and c.vscBack or c.vscLeftDark })
    hl(0, "TabLine", { fg = c.vscFront, bg = c.vscTabOther })
    hl(0, "TabLineFill", { fg = c.vscFront, bg = c.vscTabOutside })
    hl(0, "TabLineSel", { fg = c.vscFront, bg = c.vscTabCurrent })
    hl(0, "Title", { fg = c.vscNone, bg = c.vscNone, bold = true })
    hl(0, "Visual", { fg = c.vscNone, bg = c.vscSelection })
    hl(0, "VisualNOS", { fg = c.vscNone, bg = c.vscSelection })
    hl(0, "WarningMsg", { fg = c.vscRed, bg = c.vscBack, bold = true })
    hl(0, "WildMenu", { fg = c.vscNone, bg = c.vscSelection })
    hl(0, "Comment", { fg = c.vscGreen, bg = "NONE", italic = opts.italic_comments })
    hl(0, "Constant", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "String", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "Character", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "Number", { fg = c.vscLightGreen, bg = "NONE" })
    hl(0, "Boolean", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "Float", { fg = c.vscLightGreen, bg = "NONE" })
    hl(0, "Identifier", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "Function", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "Statement", { fg = c.vscPink, bg = "NONE" })
    hl(0, "Conditional", { fg = c.vscPink, bg = "NONE" })
    hl(0, "Repeat", { fg = c.vscPink, bg = "NONE" })
    hl(0, "Label", { fg = c.vscPink, bg = "NONE" })
    hl(0, "Operator", { fg = c.vscFront, bg = "NONE" })
    hl(0, "Keyword", { fg = c.vscPink, bg = "NONE" })
    hl(0, "Exception", { fg = c.vscPink, bg = "NONE" })
    hl(0, "PreProc", { fg = c.vscPink, bg = "NONE" })
    hl(0, "Include", { fg = c.vscPink, bg = "NONE" })
    hl(0, "Define", { fg = c.vscPink, bg = "NONE" })
    hl(0, "Macro", { fg = c.vscPink, bg = "NONE" })
    hl(0, "Type", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "StorageClass", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "Structure", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "Typedef", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "Special", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "SpecialChar", { fg = c.vscFront, bg = "NONE" })
    hl(0, "Tag", { fg = c.vscFront, bg = "NONE" })
    hl(0, "Delimiter", { fg = c.vscFront, bg = "NONE" })
    hl(0, "SpecialComment", { fg = c.vscGreen, bg = "NONE" })
    hl(0, "Debug", { fg = c.vscFront, bg = "NONE" })
    hl(0, "Underlined", { fg = c.vscNone, bg = "NONE", underline = true })
    hl(0, "Conceal", { fg = c.vscFront, bg = c.vscBack })
    hl(0, "Ignore", { fg = c.vscFront, bg = "NONE" })
    hl(0, "Error", { fg = c.vscRed, bg = c.vscBack, undercurl = true, sp = c.vscRed })
    hl(0, "Todo", { fg = c.vscYellowOrange, bg = c.vscBack, bold = true })
    hl(0, "SpellBad", { fg = c.vscRed, bg = c.vscBack, undercurl = true, sp = c.vscRed })
    hl(0, "SpellCap", { fg = c.vscRed, bg = c.vscBack, undercurl = true, sp = c.vscRed })
    hl(0, "SpellRare", { fg = c.vscRed, bg = c.vscBack, undercurl = true, sp = c.vscRed })
    hl(0, "SpellLocal", { fg = c.vscRed, bg = c.vscBack, undercurl = true, sp = c.vscRed })
    hl(0, "Whitespace", { fg = isDark and c.vscLineNumber or c.vscTabOther })

    -- Treesitter
    hl(0, "@error", { fg = c.vscRed, bg = "NONE" })
    hl(0, "@punctuation.bracket", { fg = c.vscFront, bg = "NONE" })
    hl(0, "@punctuation.special", { fg = c.vscFront, bg = "NONE" })
    hl(0, "@comment", { fg = c.vscGreen, bg = "NONE", italic = opts.italic_comments })
    hl(0, "@constant", { fg = c.vscAccentBlue, bg = "NONE" })
    hl(0, "@constant.builtin", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "@constant.macro", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "@string.regex", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "@string", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "@character", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "@number", { fg = c.vscLightGreen, bg = "NONE" })
    hl(0, "@boolean", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "@float", { fg = c.vscLightGreen, bg = "NONE" })
    hl(0, "@annotation", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "@attribute", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "@attribute.builtin", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "@namespace", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "@function.builtin", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "@function", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "@function.macro", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "@parameter", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "@parameter.reference", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "@method", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "@field", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "@property", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "@constructor", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "@conditional", { fg = c.vscPink, bg = "NONE" })
    hl(0, "@repeat", { fg = c.vscPink, bg = "NONE" })
    hl(0, "@label", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "@keyword", { fg = c.vscPink, bg = "NONE" })
    hl(0, "@keyword.function", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "@keyword.operator", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "@operator", { fg = c.vscFront, bg = "NONE" })
    hl(0, "@exception", { fg = c.vscPink, bg = "NONE" })
    hl(0, "@type", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "@type.builtin", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "@type.qualifier", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "@storageClass", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "@structure", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "@include", { fg = c.vscPink, bg = "NONE" })
    hl(0, "@variable", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "@variable.builtin", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "@text", { fg = c.vscFront, bg = "NONE" })
    hl(0, "@text.underline", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "@tag", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "@tag.delimiter", { fg = c.vscGray, bg = "NONE" })
    hl(0, "@tag.attribute", { fg = c.vscLightBlue, bg = "NONE" })

    hl(0, "@text.title", { fg = isDark and c.vscBlue or c.vscYellowOrange, bold = true })
    hl(0, "@text.literal", { fg = c.vscFront, bg = "NONE" })
    hl(0, "@text.literal.markdown", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "@text.literal.markdown_inline", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "@text.emphasis", { fg = c.vscFront, bg = "NONE", italic = true })
    hl(0, "@text.strong", { fg = isDark and c.vscBlue or c.vscViolet, bold = true })
    hl(0, "@text.uri", { fg = c.vscFront, bg = "NONE" })
    hl(0, "@textReference", { fg = isDark and c.vscOrange or c.vscYellowOrange })
    hl(0, "@punctuation.delimiter", { fg = c.vscFront, bg = "NONE" })
    hl(0, "@stringEscape", { fg = isDark and c.vscOrange or c.vscYellowOrange, bold = true })

    hl(0, "@text.note", { fg = c.vscBlueGreen, bg = "NONE", bold = true })
    hl(0, "@text.warning", { fg = c.vscYellowOrange, bg = "NONE", bold = true })
    hl(0, "@text.danger", { fg = c.vscRed, bg = "NONE", bold = true })

    hl(0, "@text.diff.add", { link = "DiffAdd" })
    hl(0, "@text.diff.delete", { link = "DiffDelete" })

    -- LSP semantic tokens
    hl(0, "@lsp.typemod.type.defaultLibrary", { link = "@type.builtin" })
    hl(0, "@lsp.type.type", { link = "@type" })
    hl(0, "@lsp.type.typeParameter", { link = "@type" })
    hl(0, "@lsp.type.macro", { link = "@constant" })
    hl(0, "@lsp.type.enumMember", { link = "@constant" })
    hl(0, "@event", { link = "Identifier" })
    hl(0, "@interface", { link = "Identifier" })
    hl(0, "@modifier", { link = "Identifier" })
    hl(0, "@regexp", { fg = c.vscRed, bg = "NONE" })
    hl(0, "@decorator", { link = "Identifier" })

    -- Markdown
    hl(0, "markdownBold", { fg = isDark and c.vscBlue or c.vscYellowOrange, bold = true })
    hl(0, "markdownCode", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "markdownRule", { fg = isDark and c.vscBlue or c.vscYellowOrange, bold = true })
    hl(0, "markdownCodeDelimiter", { fg = c.vscFront, bg = "NONE" })
    hl(0, "markdownHeadingDelimiter", { fg = isDark and c.vscBlue or c.vscYellowOrange, bg = "NONE" })
    hl(0, "markdownFootnote", { fg = isDark and c.vscOrange or c.vscYellowOrange, bg = "NONE" })
    hl(0, "markdownFootnoteDefinition", { fg = isDark and c.vscOrange or c.vscYellowOrange })
    hl(0, "markdownUrl", { fg = c.vscFront, bg = "NONE", underline = true })
    hl(0, "markdownLinkText", { fg = isDark and c.vscOrange or c.vscYellowOrange })
    hl(0, "markdownEscape", { fg = isDark and c.vscOrange or c.vscYellowOrange })

    -- Asciidoc
    hl(0, "asciidocAttributeEntry", { fg = c.vscYellowOrange })
    hl(0, "asciidocAttributeList", { fg = c.vscPink })
    hl(0, "asciidocAttributeRef", { fg = c.vscYellowOrange })
    hl(0, "asciidocHLabel", { fg = c.vscBlue, bold = true })
    hl(0, "asciidocListingBlock", { fg = c.vscOrange })
    hl(0, "asciidocMacroAttributes", { fg = c.vscYellowOrange })
    hl(0, "asciidocOneLineTitle", { fg = c.vscBlue, bold = true })
    hl(0, "asciidocPassthroughBlock", { fg = c.vscBlue })
    hl(0, "asciidocQuotedMonospaced", { fg = c.vscOrange })
    hl(0, "asciidocTriplePlusPassthrough", { fg = c.vscYellow })
    hl(0, "asciidocMacro", { fg = c.vscPink })
    hl(0, "asciidocAdmonition", { fg = c.vscOrange })
    hl(0, "asciidocQuotedEmphasized", { fg = c.vscBlue, italic = true })
    hl(0, "asciidocQuotedEmphasized2", { fg = c.vscBlue, italic = true })
    hl(0, "asciidocQuotedEmphasizedItalic", { fg = c.vscBlue, italic = true })
    hl(0, "asciidocBackslash", { link = "Keyword" })
    hl(0, "asciidocQuotedBold", { link = "markdownBold" })
    hl(0, "asciidocQuotedMonospaced2", { link = "asciidocQuotedMonospaced" })
    hl(0, "asciidocQuotedUnconstrainedBold", { link = "asciidocQuotedBold" })
    hl(0, "asciidocQuotedUnconstrainedEmphasized", { link = "asciidocQuotedEmphasized" })
    hl(0, "asciidocURL", { link = "markdownUrl" })

    -- JSON
    hl(0, "jsonKeyword", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsonEscape", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "jsonNull", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "jsonBoolean", { fg = c.vscBlue, bg = "NONE" })

    -- HTML
    hl(0, "htmlTag", { fg = c.vscGray, bg = "NONE" })
    hl(0, "htmlEndTag", { fg = c.vscGray, bg = "NONE" })
    hl(0, "htmlTagName", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "htmlSpecialTagName", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "htmlArg", { fg = c.vscLightBlue, bg = "NONE" })

    -- PHP
    hl(0, "phpStaticClasses", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "phpMethod", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "phpClass", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "phpFunction", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "phpInclude", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "phpUseClass", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "phpRegion", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "phpMethodsVar", { fg = c.vscLightBlue, bg = "NONE" })

    -- CSS
    hl(0, "cssBraces", { fg = c.vscFront, bg = "NONE" })
    hl(0, "cssInclude", { fg = c.vscPink, bg = "NONE" })
    hl(0, "cssTagName", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "cssClassName", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "cssPseudoClass", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "cssPseudoClassId", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "cssPseudoClassLang", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "cssIdentifier", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "cssProp", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "cssDefinition", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "cssAttr", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "cssAttrRegion", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "cssColor", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "cssFunction", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "cssFunctionName", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "cssVendor", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "cssValueNumber", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "cssValueLength", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "cssUnitDecorators", { fg = c.vscOrange, bg = "NONE" })
    hl(0, "cssStyle", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "cssImportant", { fg = c.vscBlue, bg = "NONE" })

    -- JavaScript
    hl(0, "jsVariableDef", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsFuncArgs", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsFuncBlock", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsRegexpString", { fg = c.vscLightRed, bg = "NONE" })
    hl(0, "jsThis", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "jsOperatorKeyword", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "jsDestructuringBlock", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsObjectKey", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsGlobalObjects", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "jsModuleKeyword", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsClassDefinition", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "jsClassKeyword", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "jsExtendsKeyword", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "jsExportDefault", { fg = c.vscPink, bg = "NONE" })
    hl(0, "jsFuncCall", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "jsObjectValue", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsParen", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsObjectProp", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsIfElseBlock", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsParenIfElse", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsSpreadOperator", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "jsSpreadExpression", { fg = c.vscLightBlue, bg = "NONE" })

    -- Typescript
    hl(0, "typescriptLabel", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptExceptions", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptBraces", { fg = c.vscFront, bg = "NONE" })
    hl(0, "typescriptEndColons", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptParens", { fg = c.vscFront, bg = "NONE" })
    hl(0, "typescriptDocTags", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptDocComment", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "typescriptLogicSymbols", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptImport", { fg = c.vscPink, bg = "NONE" })
    hl(0, "typescriptBOM", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptVariableDeclaration", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptVariable", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptExport", { fg = c.vscPink, bg = "NONE" })
    hl(0, "typescriptAliasDeclaration", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "typescriptAliasKeyword", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptClassName", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "typescriptAccessibilityModifier", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptOperator", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptArrowFunc", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptMethodAccessor", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptMember", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "typescriptTypeReference", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "typescriptTemplateSB", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "typescriptArrowFuncArg", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptParamImpl", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptFuncComma", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptCastKeyword", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptCall", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptCase", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptReserved", { fg = c.vscPink, bg = "NONE" })
    hl(0, "typescriptDefault", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptDecorator", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "typescriptPredefinedType", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "typescriptClassHeritage", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "typescriptClassExtends", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptClassKeyword", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptBlock", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptDOMDocProp", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptTemplateSubstitution", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptClassBlock", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptFuncCallArg", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptIndexExpr", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptConditionalParen", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptArray", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "typescriptES6SetProp", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptObjectLiteral", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptTypeParameter", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "typescriptEnumKeyword", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptEnum", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "typescriptLoopParen", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptParenExp", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptModule", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "typescriptAmbientDeclaration", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptFuncTypeArrow", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptInterfaceHeritage", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "typescriptInterfaceName", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "typescriptInterfaceKeyword", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptInterfaceExtends", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptGlobal", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "typescriptAsyncFuncKeyword", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptFuncKeyword", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "typescriptGlobalMethod", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "typescriptPromiseMethod", { fg = c.vscYellow, bg = "NONE" })

    -- XML
    hl(0, "xmlTag", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "xmlTagName", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "xmlEndTag", { fg = c.vscBlue, bg = "NONE" })

    -- Ruby
    hl(0, "rubyClassNameTag", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "rubyClassName", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "rubyModuleName", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "rubyConstant", { fg = c.vscBlueGreen, bg = "NONE" })

    -- Golang
    hl(0, "goPackage", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "goImport", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "goVar", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "goConst", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "goStatement", { fg = c.vscPink, bg = "NONE" })
    hl(0, "goType", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "goSignedInts", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "goUnsignedInts", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "goFloats", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "goComplexes", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "goBuiltins", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "goBoolean", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "goPredefinedIdentifiers", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "goTodo", { fg = c.vscGreen, bg = "NONE" })
    hl(0, "goDeclaration", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "goDeclType", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "goTypeDecl", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "goTypeName", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "goVarAssign", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "goVarDefs", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "goReceiver", { fg = c.vscFront, bg = "NONE" })
    hl(0, "goReceiverType", { fg = c.vscFront, bg = "NONE" })
    hl(0, "goFunctionCall", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "goMethodCall", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "goSingleDecl", { fg = c.vscLightBlue, bg = "NONE" })

    -- Python
    hl(0, "pythonStatement", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "pythonOperator", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "pythonException", { fg = c.vscPink, bg = "NONE" })
    hl(0, "pythonExClass", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "pythonBuiltinObj", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "pythonBuiltinType", { fg = c.vscBlueGreen, bg = "NONE" })
    hl(0, "pythonBoolean", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "pythonNone", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "pythonTodo", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "pythonClassVar", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "pythonClassDef", { fg = c.vscBlueGreen, bg = "NONE" })

    -- TeX
    hl(0, "texStatement", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "texBeginEnd", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "texBeginEndName", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "texOption", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "texBeginEndModifier", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "texDocType", { fg = c.vscPink, bg = "NONE" })
    hl(0, "texDocTypeArgs", { fg = c.vscLightBlue, bg = "NONE" })

    -- Git
    hl(0, "gitcommitHeader", { fg = c.vscGray, bg = "NONE" })
    hl(0, "gitcommitOnBranch", { fg = c.vscGray, bg = "NONE" })
    hl(0, "gitcommitBranch", { fg = c.vscPink, bg = "NONE" })
    hl(0, "gitcommitComment", { fg = c.vscGray, bg = "NONE" })
    hl(0, "gitcommitSelectedType", { fg = c.vscGreen, bg = "NONE" })
    hl(0, "gitcommitSelectedFile", { fg = c.vscGreen, bg = "NONE" })
    hl(0, "gitcommitDiscardedType", { fg = c.vscRed, bg = "NONE" })
    hl(0, "gitcommitDiscardedFile", { fg = c.vscRed, bg = "NONE" })
    hl(0, "gitcommitOverflow", { fg = c.vscRed, bg = "NONE" })
    hl(0, "gitcommitSummary", { fg = c.vscPink, bg = "NONE" })
    hl(0, "gitcommitBlank", { fg = c.vscPink, bg = "NONE" })

    -- Lua
    hl(0, "luaFuncCall", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "luaFuncArgName", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "luaFuncKeyword", { fg = c.vscPink, bg = "NONE" })
    hl(0, "luaLocal", { fg = c.vscPink, bg = "NONE" })
    hl(0, "luaBuiltIn", { fg = c.vscBlue, bg = "NONE" })

    -- SH
    hl(0, "shDeref", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "shVariable", { fg = c.vscLightBlue, bg = "NONE" })

    -- SQL
    hl(0, "sqlKeyword", { fg = c.vscPink, bg = "NONE" })
    hl(0, "sqlFunction", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "sqlOperator", { fg = c.vscPink, bg = "NONE" })

    -- YAML
    hl(0, "yamlKey", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "yamlConstant", { fg = c.vscBlue, bg = "NONE" })

    -- Gitgutter
    hl(0, "GitGutterAdd", { fg = c.vscGreen, bg = "NONE" })
    hl(0, "GitGutterChange", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "GitGutterDelete", { fg = c.vscRed, bg = "NONE" })

    -- Git Signs
    hl(0, "GitSignsAdd", { fg = c.vscGreen, bg = "NONE" })
    hl(0, "GitSignsChange", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "GitSignsDelete", { fg = c.vscRed, bg = "NONE" })
    hl(0, "GitSignsAddLn", { fg = c.vscBack, bg = c.vscGreen })
    hl(0, "GitSignsChangeLn", { fg = c.vscBack, bg = c.vscYellow })
    hl(0, "GitSignsDeleteLn", { fg = c.vscBack, bg = c.vscRed })

    -- NvimTree
    hl(0, "NvimTreeRootFolder", { fg = c.vscFront, bg = "NONE", bold = true })
    hl(0, "NvimTreeGitDirty", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "NvimTreeGitNew", { fg = c.vscGreen, bg = "NONE" })
    hl(0, "NvimTreeImageFile", { fg = c.vscViolet, bg = "NONE" })
    hl(0, "NvimTreeEmptyFolderName", { fg = c.vscGray, bg = "NONE" })
    hl(0, "NvimTreeFolderName", { fg = c.vscFront, bg = "NONE" })
    hl(0, "NvimTreeSpecialFile", { fg = c.vscPink, bg = "NONE", underline = true })
    hl(0, "NvimTreeNormal", { fg = c.vscFront, bg = opts.disable_nvimtree_bg and c.vscBack or c.vscLeftDark })
    hl(0, "NvimTreeCursorLine", { fg = "NONE", bg = opts.disable_nvimtree_bg and c.vscCursorDarkDark or c.vscLeftMid })
    hl(0, "NvimTreeVertSplit", { fg = opts.disable_nvimtree_bg and c.vscSplitDark or c.vscBack, bg = c.vscBack })
    hl(0, "NvimTreeEndOfBuffer", { fg = opts.disable_nvimtree_bg and c.vscCursorDarkDark or c.vscLeftDark })
    hl(
        0,
        "NvimTreeOpenedFolderName",
        { fg = "NONE", bg = opts.disable_nvimtree_bg and c.vscCursorDarkDark or c.vscLeftDark }
    )
    hl(0, "NvimTreeGitRenamed", { fg = c.vscGitRenamed, bg = "NONE" })
    hl(0, "NvimTreeGitIgnored", { fg = c.vscGitIgnored, bg = "NONE" })
    hl(0, "NvimTreeGitDeleted", { fg = c.vscGitDeleted, bg = "NONE" })
    hl(0, "NvimTreeGitStaged", { fg = c.vscGitStageModified, bg = "NONE" })
    hl(0, "NvimTreeGitMerge", { fg = c.vscGitUntracked, bg = "NONE" })
    hl(0, "NvimTreeGitDirty", { fg = c.vscGitModified, bg = "NONE" })
    hl(0, "NvimTreeGitNew", { fg = c.vscGitAdded, bg = "NONE" })

    -- Bufferline
    hl(0, "BufferLineIndicatorSelected", { fg = c.vscLeftDark, bg = "NONE" })
    hl(0, "BufferLineFill", { fg = "NONE", bg = opts.transparent and c.vscBack or c.vscLeftDark })

    -- BarBar
    hl(0, "BufferCurrent", { fg = c.vscFront, bg = c.vscTabCurrent })
    hl(0, "BufferCurrentIndex", { fg = c.vscFront, bg = c.vscTabCurrent })
    hl(0, "BufferCurrentMod", { fg = c.vscYellowOrange, bg = c.vscTabCurrent })
    hl(0, "BufferCurrentSign", { fg = c.vscFront, bg = c.vscTabCurrent })
    hl(0, "BufferCurrentTarget", { fg = c.vscRed, bg = c.vscTabCurrent })
    hl(0, "BufferVisible", { fg = c.vscGray, bg = c.vscTabCurrent })
    hl(0, "BufferVisibleIndex", { fg = c.vscGray, bg = c.vscTabCurrent })
    hl(0, "BufferVisibleMod", { fg = c.vscYellowOrange, bg = c.vscTabCurrent })
    hl(0, "BufferVisibleSign", { fg = c.vscGray, bg = c.vscTabCurrent })
    hl(0, "BufferVisibleTarget", { fg = c.vscRed, bg = c.vscTabCurrent })
    hl(0, "BufferInactive", { fg = c.vscGray, bg = c.vscTabOther })
    hl(0, "BufferInactiveIndex", { fg = c.vscGray, bg = c.vscTabOther })
    hl(0, "BufferInactiveMod", { fg = c.vscYellowOrange, bg = c.vscTabOther })
    hl(0, "BufferInactiveSign", { fg = c.vscGray, bg = c.vscTabOther })
    hl(0, "BufferInactiveTarget", { fg = c.vscRed, bg = c.vscTabOther })
    hl(0, "BufferTabpages", { fg = c.vscFront, bg = c.vscTabOther })
    hl(0, "BufferTabpagesFill", { fg = c.vscFront, bg = c.vscTabOther })

    -- IndentBlankLine
    hl(0, "IndentBlanklineContextChar", { fg = c.vscContextCurrent, bg = "NONE", nocombine = true })
    hl(0, "IndentBlanklineContextStart", { sp = c.vscContextCurrent, bg = "NONE", nocombine = true, underline = true })
    hl(0, "IndentBlanklineChar", { fg = c.vscContext, bg = "NONE", nocombine = true })
    hl(0, "IndentBlanklineSpaceChar", { fg = c.vscContext, bg = "NONE", nocombine = true })
    hl(0, "IndentBlanklineSpaceCharBlankline", { fg = c.vscContext, bg = "NONE", nocombine = true })

    -- LSP
    hl(0, "DiagnosticError", { fg = c.vscRed, bg = "NONE" })
    hl(0, "DiagnosticWarn", { fg = c.vscYellow, bg = "NONE" })
    hl(0, "DiagnosticInfo", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "DiagnosticHint", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "DiagnosticUnderlineError", { fg = "NONE", bg = "NONE", undercurl = true, sp = c.vscRed })
    hl(0, "DiagnosticUnderlineWarn", { fg = "NONE", bg = "NONE", undercurl = true, sp = c.vscYellow })
    hl(0, "DiagnosticUnderlineInfo", { fg = "NONE", bg = "NONE", undercurl = true, sp = c.vscBlue })
    hl(0, "DiagnosticUnderlineHint", { fg = "NONE", bg = "NONE", undercurl = true, sp = c.vscBlue })
    hl(0, "LspReferenceText", { fg = "NONE", bg = isDark and c.vscPopupHighlightGray or c.vscPopupHighlightLightBlue })
    hl(0, "LspReferenceRead", { fg = "NONE", bg = isDark and c.vscPopupHighlightGray or c.vscPopupHighlightLightBlue })
    hl(0, "LspReferenceWrite", { fg = "NONE", bg = isDark and c.vscPopupHighlightGray or c.vscPopupHighlightLightBlue })

    -- COC.nvim
    hl(0, "CocHighlightText", { fg = "NONE", bg = isDark and c.vscPopupHighlightGray or c.vscPopupHighlightLightBlue })
    hl(0, "CocHighlightRead", { fg = "NONE", bg = isDark and c.vscPopupHighlightGray or c.vscPopupHighlightLightBlue })
    hl(0, "CocHighlightWrite", { fg = "NONE", bg = isDark and c.vscPopupHighlightGray or c.vscPopupHighlightLightBlue })

    -- Nvim compe
    hl(0, "CmpItemKindVariable", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "CmpItemKindInterface", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "CmpItemKindText", { fg = c.vscLightBlue, bg = "NONE" })
    hl(0, "CmpItemKindFunction", { fg = c.vscPink, bg = "NONE" })
    hl(0, "CmpItemKindMethod", { fg = c.vscPink, bg = "NONE" })
    hl(0, "CmpItemKindKeyword", { fg = c.vscFront, bg = "NONE" })
    hl(0, "CmpItemKindProperty", { fg = c.vscFront, bg = "NONE" })
    hl(0, "CmpItemKindUnit", { fg = c.vscFront, bg = "NONE" })
    hl(0, "CmpItemKindConstructor", { fg = c.vscUiOrange, bg = "NONE" })
    hl(0, "CmpItemMenu", { fg = c.vscPopupFront, bg = "NONE" })
    hl(0, "CmpItemAbbr", { fg = c.vscFront, bg = "NONE" })
    hl(0, "CmpItemAbbrDeprecated", { fg = c.vscCursorDark, bg = c.vscPopupBack, strikethrough = true })
    hl(0, "CmpItemAbbrMatch", { fg = isDark and c.vscMediumBlue or c.vscDarkBlue, bg = "NONE", bold = true })
    hl(0, "CmpItemAbbrMatchFuzzy", { fg = isDark and c.vscMediumBlue or c.vscDarkBlue, bg = "NONE", bold = true })

    -- Dashboard
    hl(0, "DashboardHeader", { fg = c.vscBlue, bg = "NONE" })
    hl(0, "DashboardDesc", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "DashboardIcon", { fg = c.vscYellowOrange, bg = "NONE" })
    hl(0, "DashboardShortCut", { fg = c.vscPink, bg = "NONE" })
    hl(0, "DashboardKey", { fg = c.vscWhite, bg = "NONE" })
    hl(0, "DashboardFooter", { fg = c.vscBlue, bg = "NONE", italic = true })

    if isDark then
        hl(0, "NvimTreeFolderIcon", { fg = c.vscBlue, bg = "NONE" })
        hl(0, "NvimTreeIndentMarker", { fg = c.vscLineNumber, bg = "NONE" })

        hl(0, "LspFloatWinNormal", { fg = c.vscFront, bg = "NONE" })
        hl(0, "LspFloatWinBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaHoverBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaSignatureHelpBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaCodeActionBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaDefPreviewBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspLinesDiagBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaRenameBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaBorderTitle", { fg = c.vscCursorDark, bg = "NONE" })
        hl(0, "LSPSagaDiagnosticTruncateLine", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaDiagnosticBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaDiagnosticBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaShTruncateLine", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaShTruncateLine", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaDocTruncateLine", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaRenameBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "LspSagaLspFinderBorder", { fg = c.vscLineNumber, bg = "NONE" })

        hl(0, "TelescopePromptBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "TelescopeResultsBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "TelescopePreviewBorder", { fg = c.vscLineNumber, bg = "NONE" })
        hl(0, "TelescopeNormal", { fg = c.vscFront, bg = "NONE" })
        hl(0, "TelescopeSelection", { fg = c.vscFront, bg = c.vscPopupHighlightBlue })
        hl(0, "TelescopeMultiSelection", { fg = c.vscFront, bg = c.vscPopupHighlightBlue })
        hl(0, "TelescopeMatching", { fg = c.vscMediumBlue, bg = "NONE", bold = true })
        hl(0, "TelescopePromptPrefix", { fg = c.vscFront, bg = "NONE" })

        -- symbols-outline
        -- white fg and lualine blue bg
        hl(0, "FocusedSymbol", { fg = "#ffffff", bg = c.vscUiBlue })
        hl(0, "SymbolsOutlineConnector", { fg = c.vscLineNumber, bg = "NONE" })
    else
        hl(0, "NvimTreeFolderIcon", { fg = c.vscDarkBlue, bg = "NONE" })
        hl(0, "NvimTreeIndentMarker", { fg = c.vscTabOther, bg = "NONE" })

        hl(0, "LspFloatWinNormal", { fg = c.vscFront, bg = "NONE" })
        hl(0, "LspFloatWinBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaHoverBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaSignatureHelpBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaCodeActionBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaDefPreviewBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspLinesDiagBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaRenameBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaBorderTitle", { fg = c.vscCursorDark, bg = "NONE" })
        hl(0, "LSPSagaDiagnosticTruncateLine", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaDiagnosticBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaDiagnosticBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaShTruncateLine", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaShTruncateLine", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaDocTruncateLine", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaRenameBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "LspSagaLspFinderBorder", { fg = c.vscTabOther, bg = "NONE" })

        hl(0, "TelescopePromptBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "TelescopeResultsBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "TelescopePreviewBorder", { fg = c.vscTabOther, bg = "NONE" })
        hl(0, "TelescopeNormal", { fg = c.vscFront, bg = "NONE" })
        hl(0, "TelescopeSelection", { fg = "#FFFFFF", bg = c.vscPopupHighlightBlue })
        hl(0, "TelescopeMultiSelection", { fg = c.vscBack, bg = c.vscPopupHighlightBlue })
        hl(0, "TelescopeMatching", { fg = "orange", bg = "NONE", bold = true, nil })
        hl(0, "TelescopePromptPrefix", { fg = c.vscFront, bg = "NONE" })

        -- COC.nvim
        hl(0, "CocFloating", { fg = "NONE", bg = c.vscPopupBack })
        hl(0, "CocMenuSel", { fg = "#FFFFFF", bg = "#285EBA" })
        hl(0, "CocSearch", { fg = "#2A64B9", bg = "NONE" })

        -- Pmenu
        hl(0, "Pmenu", { fg = "NONE", bg = c.vscPopupBack })
        hl(0, "PmenuSel", { fg = "#FFFFFF", bg = "#285EBA" })

        -- symbols-outline
        -- white fg and lualine blue bg
        hl(0, "FocusedSymbol", { fg = c.vscBack, bg = "#AF00DB" })
        hl(0, "SymbolsOutlineConnector", { fg = c.vscTabOther, bg = "NONE" })
    end
end

theme.link_highlight = function()
    -- Legacy groups for official git.vim and diff.vim syntax
    hl(0, "diffAdded", { link = "DiffAdd" })
    hl(0, "diffChanged", { link = "DiffChange" })
    hl(0, "diffRemoved", { link = "DiffDelete" })
    -- Nvim compe
    hl(0, "CompeDocumentation", { link = "Pmenu" })
    hl(0, "CompeDocumentationBorder", { link = "Pmenu" })
    hl(0, "CmpItemKind", { link = "Pmenu" })
    hl(0, "CmpItemKindClass", { link = "CmpItemKindConstructor" })
    hl(0, "CmpItemKindModule", { link = "CmpItemKindKeyword" })
    hl(0, "CmpItemKindOperator", { link = "@operator" })
    hl(0, "CmpItemKindReference", { link = "@parameter.reference" })
    hl(0, "CmpItemKindValue", { link = "@field" })
    hl(0, "CmpItemKindField", { link = "@field" })
    hl(0, "CmpItemKindEnum", { link = "@field" })
    hl(0, "CmpItemKindSnippet", { link = "@text" })
    hl(0, "CmpItemKindColor", { link = "cssColor" })
    hl(0, "CmpItemKindFile", { link = "@text.uri" })
    hl(0, "CmpItemKindFolder", { link = "@text.uri" })
    hl(0, "CmpItemKindEvent", { link = "@constant" })
    hl(0, "CmpItemKindEnumMember", { link = "@field" })
    hl(0, "CmpItemKindConstant", { link = "@constant" })
    hl(0, "CmpItemKindStruct", { link = "@structure" })
    hl(0, "CmpItemKindTypeParameter", { link = "@parameter" })
end

-- Pass setup to config module
vscode.setup = config.setup

-- Load colorscheme with a given or default style
---@param style? string
vscode.load = function(style)
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end

    vim.o.termguicolors = true
    vim.g.colors_name = "vscode"

    vim.o.background = style or config.opts.style or vim.o.background

    theme.set_highlights(config.opts)
    theme.link_highlight()

    if config.opts.group_overrides then
        for group, val in pairs(config.opts["group_overrides"]) do
            vim.api.nvim_set_hl(0, group, val)
        end
    end
end

vscode.load()

-- hacky way to get the config across to lualine - can go when the config goes
M.config = config
return M
