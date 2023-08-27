-- PAX scheme, influenced heavily by the vs code dark plus theme,
-- shamelessly pillaged from https://github.com/Mofiqul/ode.nvim/tree/main

-- CONFIG
local use_italic_comments = true

-- COLORS
-- TODO see if there is any consolidation that can be done here (if we have repeated of any
-- strings, also we have a mixture of cases)
local colors = {
    none = "NONE",
    front = "#D4D4D4",
    back = "#1E1E1E",

    tabCurrent = "#1E1E1E",
    tabOther = "#2D2D2D",
    tabOutside = "#252526",

    leftDark = "#252526",
    leftMid = "#373737",
    leftLight = "#636369",

    popupFront = "#BBBBBB",
    popupBack = "#272727",
    popupHighlightBlue = "#004b72",
    popupHighlightGray = "#343B41",

    splitLight = "#898989",
    splitDark = "#444444",
    splitThumb = "#424242",

    cursorDarkDark = "#222222",
    cursorDark = "#51504F",
    cursorLight = "#AEAFAD",
    selection = "#264F78",
    lineNumber = "#5A5A5A",

    diffRedDark = "#4B1818",
    diffRedLight = "#6F1313",
    diffRedLightLight = "#FB0101",
    diffGreenDark = "#373D29",
    diffGreenLight = "#4B5632",
    searchCurrent = "#515c6a",
    search = "#613315",

    gitAdded = "#81b88b",
    gitModified = "#e2c08d",
    gitDeleted = "#c74e39",
    gitRenamed = "#73c991",
    gitUntracked = "#73c991",
    gitIgnored = "#8c8c8c",
    gitStageModified = "#e2c08d",
    gitStageDeleted = "#c74e39",
    gitConflicting = "#e4676b",
    gitSubmodule = "#8db9e2",

    context = "#404040",
    contextCurrent = "#707070",

    foldBackground = "#202d39",

    -- Syntax colors
    gray = "#808080",
    violet = "#646695",
    blue = "#569CD6",
    accentBlue = "#4FC1FE",
    darkBlue = "#223E55",
    mediumBlue = "#18a2fe",
    lightBlue = "#9CDCFE",
    green = "#6A9955",
    blueGreen = "#4EC9B0",
    lightGreen = "#B5CEA8",
    red = "#F44747",
    orange = "#CE9178",
    lightRed = "#D16969",
    yellowOrange = "#D7BA7D",
    yellow = "#DCDCAA",
    darkYellow = "#FFD602",
    pink = "#C586C0",
    -- colours below were constant between light/dark themes
    uiBlue = "#084671",
    uiOrange = "#f28b25",
    popupHighlightLightBlue = "#d7eafe",
}

-- I think that this clears anything that exists, which is perhaps redundant
-- given that I think the way hl() is called blasts existing config away.
-- Probably sensible to keep this though as I'd hope it would make it clear
-- when we have items that need a bit of attention in new plugins.
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end

vim.g.colors_name = "pax"

-- HELPER
-- TODO - this looks good with all the none's filtered out, so let's remove them all
-- to make this file less noisy
local function set_highlights(highlights)
    for hl_name, hl_val in pairs(highlights) do
        local filtered_hl_val = {}
        -- just try filtering out the "NONE"s and see if it makes a difference
        for k, v in pairs(hl_val) do
            if v ~= "NONE" then
                filtered_hl_val[k] = v
            end
        end
        vim.api.nvim_set_hl(0, hl_name, filtered_hl_val)
    end
end

-- HIGHLIGHT GROUPS
-- nb a _lot_ of stuff was deleted from here. original ref is at
-- https://github.com/Mofiqul/vscode.nvim/blob/main/lua.vscode/theme.lua
local c = colors

-- We split by area here - expect these will be pulled out into separate files
-- when the overall structure is decided.
local builtins = {
    -- General
    Normal = { fg = c.front, bg = c.back },
    ColorColumn = { fg = "NONE", bg = c.cursorDarkDark },
    Cursor = { fg = c.cursorDark, bg = c.cursorLight },
    CursorLine = { bg = c.cursorDarkDark },
    CursorColumn = { fg = "NONE", bg = c.cursorDarkDark },
    Directory = { fg = c.blue, bg = c.back },
    DiffAdd = { fg = "NONE", bg = c.diffGreenLight },
    DiffChange = { fg = "NONE", bg = c.diffRedDark },
    DiffDelete = { fg = "NONE", bg = c.diffRedLight },
    DiffText = { fg = "NONE", bg = c.diffRedLight },
    EndOfBuffer = { fg = c.back, bg = "NONE" },
    ErrorMsg = { fg = c.red, bg = c.back },
    VertSplit = { fg = c.splitDark, bg = c.back },
    Folded = { fg = "NONE", bg = c.foldBackground },
    FoldColumn = { fg = c.lineNumber, bg = c.back },
    SignColumn = { fg = "NONE", bg = c.back },
    IncSearch = { fg = c.none, bg = c.searchCurrent },
    LineNr = { fg = c.lineNumber, bg = c.back },
    CursorLineNr = { fg = c.popupFront, bg = c.back },
    MatchParen = { fg = c.none, bg = c.cursorDark },
    ModeMsg = { fg = c.front, bg = c.leftDark },
    MoreMsg = { fg = c.front, bg = c.leftDark },
    NonText = { fg = c.lineNumber, bg = c.none },
    Pmenu = { fg = c.popupFront, bg = c.popupBack },
    PmenuSel = { fg = c.popupFront, bg = c.popupHighlightBlue },
    PmenuSbar = { fg = "NONE", bg = c.popupHighlightGray },
    PmenuThumb = { fg = "NONE", bg = c.popupFront },
    Question = { fg = c.blue, bg = c.back },
    Search = { fg = c.none, bg = c.search },
    SpecialKey = { fg = c.blue, bg = c.none },
    StatusLine = { fg = c.front, bg = c.leftMid },
    StatusLineNC = { fg = c.front, bg = c.leftDark },
    TabLine = { fg = c.front, bg = c.tabOther },
    TabLineFill = { fg = c.front, bg = c.tabOutside },
    TabLineSel = { fg = c.front, bg = c.tabCurrent },
    Title = { fg = c.none, bg = c.none, bold = true },
    Visual = { fg = c.none, bg = c.selection },
    VisualNOS = { fg = c.none, bg = c.selection },
    WarningMsg = { fg = c.red, bg = c.back, bold = true },
    WildMenu = { fg = c.none, bg = c.selection },
    Comment = { fg = c.green, bg = "NONE", italic = use_italic_comments },
    Constant = { fg = c.blue, bg = "NONE" },
    String = { fg = c.orange, bg = "NONE" },
    Character = { fg = c.orange, bg = "NONE" },
    Number = { fg = c.lightGreen, bg = "NONE" },
    Boolean = { fg = c.blue, bg = "NONE" },
    Float = { fg = c.lightGreen, bg = "NONE" },
    Identifier = { fg = c.lightBlue, bg = "NONE" },
    Function = { fg = c.yellow, bg = "NONE" },
    Statement = { fg = c.pink, bg = "NONE" },
    Conditional = { fg = c.pink, bg = "NONE" },
    Repeat = { fg = c.pink, bg = "NONE" },
    Label = { fg = c.pink, bg = "NONE" },
    Operator = { fg = c.front, bg = "NONE" },
    Keyword = { fg = c.pink, bg = "NONE" },
    Exception = { fg = c.pink, bg = "NONE" },
    PreProc = { fg = c.pink, bg = "NONE" },
    Include = { fg = c.pink, bg = "NONE" },
    Define = { fg = c.pink, bg = "NONE" },
    Macro = { fg = c.pink, bg = "NONE" },
    Type = { fg = c.blue, bg = "NONE" },
    StorageClass = { fg = c.blue, bg = "NONE" },
    Structure = { fg = c.blueGreen, bg = "NONE" },
    Typedef = { fg = c.blue, bg = "NONE" },
    Special = { fg = c.yellowOrange, bg = "NONE" },
    SpecialChar = { fg = c.front, bg = "NONE" },
    Tag = { fg = c.front, bg = "NONE" },
    Delimiter = { fg = c.front, bg = "NONE" },
    SpecialComment = { fg = c.green, bg = "NONE" },
    Debug = { fg = c.front, bg = "NONE" },
    Underlined = { fg = c.none, bg = "NONE", underline = true },
    Conceal = { fg = c.front, bg = c.back },
    Ignore = { fg = c.front, bg = "NONE" },
    Error = { fg = c.red, bg = c.back, undercurl = true, sp = c.vscRed },
    Todo = { fg = c.yellowOrange, bg = c.back, bold = true },
    SpellBad = { fg = c.red, bg = c.back, undercurl = true, sp = c.vscRed },
    SpellCap = { fg = c.red, bg = c.back, undercurl = true, sp = c.vscRed },
    SpellRare = { fg = c.red, bg = c.back, undercurl = true, sp = c.vscRed },
    SpellLocal = { fg = c.red, bg = c.back, undercurl = true, sp = c.vscRed },
    Whitespace = { fg = c.lineNumber },

    -- LSP
    DiagnosticError = { fg = c.red, bg = "NONE" },
    DiagnosticWarn = { fg = c.yellow, bg = "NONE" },
    DiagnosticInfo = { fg = c.blue, bg = "NONE" },
    DiagnosticHint = { fg = c.blue, bg = "NONE" },
    DiagnosticUnderlineError = { fg = "NONE", bg = "NONE", undercurl = true, sp = c.red },
    DiagnosticUnderlineWarn = { fg = "NONE", bg = "NONE", undercurl = true, sp = c.yellow },
    DiagnosticUnderlineInfo = { fg = "NONE", bg = "NONE", undercurl = true, sp = c.blue },
    DiagnosticUnderlineHint = { fg = "NONE", bg = "NONE", undercurl = true, sp = c.blue },
    LspReferenceText = { fg = "NONE", bg = c.popupHighlightGray },
    LspReferenceRead = { fg = "NONE", bg = c.popupHighlightGray },
    LspReferenceWrite = { fg = "NONE", bg = c.popupHighlightGray },
    -- find out if this is an internal, I think it probably is, or perhaps
    -- it is used by nvim lsp config? who knows
    LspFloatWinNormal = { fg = c.front, bg = "NONE" },
    LspFloatWinBorder = { fg = c.lineNumber, bg = "NONE" },

    -- Legacy groups for official git.vim and diff.vim syntax
    diffAdded = { link = "DiffAdd" },
    diffChanged = { link = "DiffChange" },
    diffRemoved = { link = "DiffDelete" },
}
set_highlights(builtins)

local plugins = {
    -- Treesitter
    ["@error"] = { fg = c.red, bg = "NONE" },
    ["@punctuation.bracket"] = { fg = c.front, bg = "NONE" },
    ["@punctuation.special"] = { fg = c.front, bg = "NONE" },
    ["@comment"] = { fg = c.green, bg = "NONE", italic = use_italic_comments },
    ["@constant"] = { fg = c.accentBlue, bg = "NONE" },
    ["@constant.builtin"] = { fg = c.blue, bg = "NONE" },
    ["@constant.macro"] = { fg = c.blueGreen, bg = "NONE" },
    ["@string.regex"] = { fg = c.orange, bg = "NONE" },
    ["@string"] = { fg = c.orange, bg = "NONE" },
    ["@character"] = { fg = c.orange, bg = "NONE" },
    ["@number"] = { fg = c.lightGreen, bg = "NONE" },
    ["@boolean"] = { fg = c.blue, bg = "NONE" },
    ["@float"] = { fg = c.lightGreen, bg = "NONE" },
    ["@annotation"] = { fg = c.yellow, bg = "NONE" },
    ["@attribute"] = { fg = c.yellow, bg = "NONE" },
    ["@attribute.builtin"] = { fg = c.blueGreen, bg = "NONE" },
    ["@namespace"] = { fg = c.blueGreen, bg = "NONE" },
    ["@function.builtin"] = { fg = c.yellow, bg = "NONE" },
    ["@function"] = { fg = c.yellow, bg = "NONE" },
    ["@function.macro"] = { fg = c.yellow, bg = "NONE" },
    ["@parameter"] = { fg = c.lightBlue, bg = "NONE" },
    ["@parameter.reference"] = { fg = c.lightBlue, bg = "NONE" },
    ["@method"] = { fg = c.yellow, bg = "NONE" },
    ["@field"] = { fg = c.lightBlue, bg = "NONE" },
    ["@property"] = { fg = c.lightBlue, bg = "NONE" },
    ["@constructor"] = { fg = c.blueGreen, bg = "NONE" },
    ["@conditional"] = { fg = c.pink, bg = "NONE" },
    ["@repeat"] = { fg = c.pink, bg = "NONE" },
    ["@label"] = { fg = c.lightBlue, bg = "NONE" },
    ["@keyword"] = { fg = c.pink, bg = "NONE" },
    ["@keyword.function"] = { fg = c.blue, bg = "NONE" },
    ["@keyword.operator"] = { fg = c.blue, bg = "NONE" },
    ["@operator"] = { fg = c.front, bg = "NONE" },
    ["@exception"] = { fg = c.pink, bg = "NONE" },
    ["@type"] = { fg = c.blueGreen, bg = "NONE" },
    ["@type.builtin"] = { fg = c.blue, bg = "NONE" },
    ["@type.qualifier"] = { fg = c.blue, bg = "NONE" },
    ["@storageClass"] = { fg = c.blue, bg = "NONE" },
    ["@structure"] = { fg = c.lightBlue, bg = "NONE" },
    ["@include"] = { fg = c.pink, bg = "NONE" },
    ["@variable"] = { fg = c.lightBlue, bg = "NONE" },
    ["@variable.builtin"] = { fg = c.lightBlue, bg = "NONE" },
    ["@text"] = { fg = c.front, bg = "NONE" },
    ["@text.underline"] = { fg = c.yellowOrange, bg = "NONE" },
    ["@tag"] = { fg = c.blue, bg = "NONE" },
    ["@tag.delimiter"] = { fg = c.gray, bg = "NONE" },
    ["@tag.attribute"] = { fg = c.lightBlue, bg = "NONE" },
    ["@text.title"] = { fg = c.blue, bold = true },
    ["@text.literal"] = { fg = c.front, bg = "NONE" },
    ["@text.literal.markdown"] = { fg = c.orange, bg = "NONE" },
    ["@text.literal.markdown_inline"] = { fg = c.orange, bg = "NONE" },
    ["@text.emphasis"] = { fg = c.front, bg = "NONE", italic = true },
    ["@text.strong"] = { fg = c.blue, bold = true },
    ["@text.uri"] = { fg = c.front, bg = "NONE" },
    ["@textReference"] = { fg = c.orange },
    ["@punctuation.delimiter"] = { fg = c.front, bg = "NONE" },
    ["@stringEscape"] = { fg = c.orange, bold = true },
    ["@text.note"] = { fg = c.blueGreen, bg = "NONE", bold = true },
    ["@text.warning"] = { fg = c.yellowOrange, bg = "NONE", bold = true },
    ["@text.danger"] = { fg = c.red, bg = "NONE", bold = true },
    ["@text.diff.add"] = { link = "DiffAdd" },
    ["@text.diff.delete"] = { link = "DiffDelete" },

    -- LSP semantic tokens
    ["@lsp.typemod.type.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeParameter"] = { link = "@type" },
    ["@lsp.type.macro"] = { link = "@constant" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@event"] = { link = "Identifier" },
    ["@interface"] = { link = "Identifier" },
    ["@modifier"] = { link = "Identifier" },
    ["@regexp"] = { fg = c.red, bg = "NONE" },
    ["@decorator"] = { link = "Identifier" },

    -- Telescope
    TelescopePromptBorder = { fg = c.lineNumber, bg = "NONE" },
    TelescopeResultsBorder = { fg = c.lineNumber, bg = "NONE" },
    TelescopePreviewBorder = { fg = c.lineNumber, bg = "NONE" },
    TelescopeNormal = { fg = c.front, bg = "NONE" },
    TelescopeSelection = { fg = c.front, bg = c.popupHighlightBlue },
    TelescopeMultiSelection = { fg = c.front, bg = c.popupHighlightBlue },
    TelescopeMatching = { fg = c.mediumBlue, bg = "NONE", bold = true },
    TelescopePromptPrefix = { fg = c.front, bg = "NONE" },

    -- ...Lualine?
    -- symbols-outline
    -- white fg and lualine blue bg
    FocusedSymbol = { fg = "#ffffff", bg = c.uiBlue },
    SymbolsOutlineConnector = { fg = c.lineNumber, bg = "NONE" },
}
set_highlights(plugins)

local languages = {
    -- Markdown
    markdownBold = { fg = c.blue, bold = true },
    markdownCode = { fg = c.orange, bg = "NONE" },
    markdownRule = { fg = c.blue, bold = true },
    markdownCodeDelimiter = { fg = c.front, bg = "NONE" },
    markdownHeadingDelimiter = { fg = c.blue, bg = "NONE" },
    markdownFootnote = { fg = c.orange, bg = "NONE" },
    markdownFootnoteDefinition = { fg = c.orange },
    markdownUrl = { fg = c.front, bg = "NONE", underline = true },
    markdownLinkText = { fg = c.orange },
    markdownEscape = { fg = c.orange },

    -- Asciidoc
    asciidocAttributeEntry = { fg = c.yellowOrange },
    asciidocAttributeList = { fg = c.pink },
    asciidocAttributeRef = { fg = c.yellowOrange },
    asciidocHLabel = { fg = c.blue, bold = true },
    asciidocListingBlock = { fg = c.orange },
    asciidocMacroAttributes = { fg = c.yellowOrange },
    asciidocOneLineTitle = { fg = c.blue, bold = true },
    asciidocPassthroughBlock = { fg = c.blue },
    asciidocQuotedMonospaced = { fg = c.orange },
    asciidocTriplePlusPassthrough = { fg = c.yellow },
    asciidocMacro = { fg = c.pink },
    asciidocAdmonition = { fg = c.orange },
    asciidocQuotedEmphasized = { fg = c.blue, italic = true },
    asciidocQuotedEmphasized2 = { fg = c.blue, italic = true },
    asciidocQuotedEmphasizedItalic = { fg = c.blue, italic = true },
    asciidocBackslash = { link = "Keyword" },
    asciidocQuotedBold = { link = "markdownBold" },
    asciidocQuotedMonospaced2 = { link = "asciidocQuotedMonospaced" },
    asciidocQuotedUnconstrainedBold = { link = "asciidocQuotedBold" },
    asciidocQuotedUnconstrainedEmphasized = { link = "asciidocQuotedEmphasized" },
    asciidocURL = { link = "markdownUrl" },

    -- JSON
    jsonKeyword = { fg = c.lightBlue, bg = "NONE" },
    jsonEscape = { fg = c.yellowOrange, bg = "NONE" },
    jsonNull = { fg = c.blue, bg = "NONE" },
    jsonBoolean = { fg = c.blue, bg = "NONE" },

    -- HTML
    htmlTag = { fg = c.gray, bg = "NONE" },
    htmlEndTag = { fg = c.gray, bg = "NONE" },
    htmlTagName = { fg = c.blue, bg = "NONE" },
    htmlSpecialTagName = { fg = c.blue, bg = "NONE" },
    htmlArg = { fg = c.lightBlue, bg = "NONE" },

    -- CSS
    cssBraces = { fg = c.front, bg = "NONE" },
    cssInclude = { fg = c.pink, bg = "NONE" },
    cssTagName = { fg = c.yellowOrange, bg = "NONE" },
    cssClassName = { fg = c.yellowOrange, bg = "NONE" },
    cssPseudoClass = { fg = c.yellowOrange, bg = "NONE" },
    cssPseudoClassId = { fg = c.yellowOrange, bg = "NONE" },
    cssPseudoClassLang = { fg = c.yellowOrange, bg = "NONE" },
    cssIdentifier = { fg = c.yellowOrange, bg = "NONE" },
    cssProp = { fg = c.lightBlue, bg = "NONE" },
    cssDefinition = { fg = c.lightBlue, bg = "NONE" },
    cssAttr = { fg = c.orange, bg = "NONE" },
    cssAttrRegion = { fg = c.orange, bg = "NONE" },
    cssColor = { fg = c.orange, bg = "NONE" },
    cssFunction = { fg = c.orange, bg = "NONE" },
    cssFunctionName = { fg = c.orange, bg = "NONE" },
    cssVendor = { fg = c.orange, bg = "NONE" },
    cssValueNumber = { fg = c.orange, bg = "NONE" },
    cssValueLength = { fg = c.orange, bg = "NONE" },
    cssUnitDecorators = { fg = c.orange, bg = "NONE" },
    cssStyle = { fg = c.lightBlue, bg = "NONE" },
    cssImportant = { fg = c.blue, bg = "NONE" },

    -- JavaScript
    jsVariableDef = { fg = c.lightBlue, bg = "NONE" },
    jsFuncArgs = { fg = c.lightBlue, bg = "NONE" },
    jsFuncBlock = { fg = c.lightBlue, bg = "NONE" },
    jsRegexpString = { fg = c.lightRed, bg = "NONE" },
    jsThis = { fg = c.blue, bg = "NONE" },
    jsOperatorKeyword = { fg = c.blue, bg = "NONE" },
    jsDestructuringBlock = { fg = c.lightBlue, bg = "NONE" },
    jsObjectKey = { fg = c.lightBlue, bg = "NONE" },
    jsGlobalObjects = { fg = c.blueGreen, bg = "NONE" },
    jsModuleKeyword = { fg = c.lightBlue, bg = "NONE" },
    jsClassDefinition = { fg = c.blueGreen, bg = "NONE" },
    jsClassKeyword = { fg = c.blue, bg = "NONE" },
    jsExtendsKeyword = { fg = c.blue, bg = "NONE" },
    jsExportDefault = { fg = c.pink, bg = "NONE" },
    jsFuncCall = { fg = c.yellow, bg = "NONE" },
    jsObjectValue = { fg = c.lightBlue, bg = "NONE" },
    jsParen = { fg = c.lightBlue, bg = "NONE" },
    jsObjectProp = { fg = c.lightBlue, bg = "NONE" },
    jsIfElseBlock = { fg = c.lightBlue, bg = "NONE" },
    jsParenIfElse = { fg = c.lightBlue, bg = "NONE" },
    jsSpreadOperator = { fg = c.lightBlue, bg = "NONE" },
    jsSpreadExpression = { fg = c.lightBlue, bg = "NONE" },

    -- Typescript
    typescriptLabel = { fg = c.lightBlue, bg = "NONE" },
    typescriptExceptions = { fg = c.lightBlue, bg = "NONE" },
    typescriptBraces = { fg = c.front, bg = "NONE" },
    typescriptEndColons = { fg = c.lightBlue, bg = "NONE" },
    typescriptParens = { fg = c.front, bg = "NONE" },
    typescriptDocTags = { fg = c.blue, bg = "NONE" },
    typescriptDocComment = { fg = c.blueGreen, bg = "NONE" },
    typescriptLogicSymbols = { fg = c.lightBlue, bg = "NONE" },
    typescriptImport = { fg = c.pink, bg = "NONE" },
    typescriptBOM = { fg = c.lightBlue, bg = "NONE" },
    typescriptVariableDeclaration = { fg = c.lightBlue, bg = "NONE" },
    typescriptVariable = { fg = c.blue, bg = "NONE" },
    typescriptExport = { fg = c.pink, bg = "NONE" },
    typescriptAliasDeclaration = { fg = c.blueGreen, bg = "NONE" },
    typescriptAliasKeyword = { fg = c.blue, bg = "NONE" },
    typescriptClassName = { fg = c.blueGreen, bg = "NONE" },
    typescriptAccessibilityModifier = { fg = c.blue, bg = "NONE" },
    typescriptOperator = { fg = c.blue, bg = "NONE" },
    typescriptArrowFunc = { fg = c.blue, bg = "NONE" },
    typescriptMethodAccessor = { fg = c.blue, bg = "NONE" },
    typescriptMember = { fg = c.yellow, bg = "NONE" },
    typescriptTypeReference = { fg = c.blueGreen, bg = "NONE" },
    typescriptTemplateSB = { fg = c.yellowOrange, bg = "NONE" },
    typescriptArrowFuncArg = { fg = c.lightBlue, bg = "NONE" },
    typescriptParamImpl = { fg = c.lightBlue, bg = "NONE" },
    typescriptFuncComma = { fg = c.lightBlue, bg = "NONE" },
    typescriptCastKeyword = { fg = c.lightBlue, bg = "NONE" },
    typescriptCall = { fg = c.blue, bg = "NONE" },
    typescriptCase = { fg = c.lightBlue, bg = "NONE" },
    typescriptReserved = { fg = c.pink, bg = "NONE" },
    typescriptDefault = { fg = c.lightBlue, bg = "NONE" },
    typescriptDecorator = { fg = c.yellow, bg = "NONE" },
    typescriptPredefinedType = { fg = c.blueGreen, bg = "NONE" },
    typescriptClassHeritage = { fg = c.blueGreen, bg = "NONE" },
    typescriptClassExtends = { fg = c.blue, bg = "NONE" },
    typescriptClassKeyword = { fg = c.blue, bg = "NONE" },
    typescriptBlock = { fg = c.lightBlue, bg = "NONE" },
    typescriptDOMDocProp = { fg = c.lightBlue, bg = "NONE" },
    typescriptTemplateSubstitution = { fg = c.lightBlue, bg = "NONE" },
    typescriptClassBlock = { fg = c.lightBlue, bg = "NONE" },
    typescriptFuncCallArg = { fg = c.lightBlue, bg = "NONE" },
    typescriptIndexExpr = { fg = c.lightBlue, bg = "NONE" },
    typescriptConditionalParen = { fg = c.lightBlue, bg = "NONE" },
    typescriptArray = { fg = c.yellow, bg = "NONE" },
    typescriptES6SetProp = { fg = c.lightBlue, bg = "NONE" },
    typescriptObjectLiteral = { fg = c.lightBlue, bg = "NONE" },
    typescriptTypeParameter = { fg = c.blueGreen, bg = "NONE" },
    typescriptEnumKeyword = { fg = c.blue, bg = "NONE" },
    typescriptEnum = { fg = c.blueGreen, bg = "NONE" },
    typescriptLoopParen = { fg = c.lightBlue, bg = "NONE" },
    typescriptParenExp = { fg = c.lightBlue, bg = "NONE" },
    typescriptModule = { fg = c.lightBlue, bg = "NONE" },
    typescriptAmbientDeclaration = { fg = c.blue, bg = "NONE" },
    typescriptFuncTypeArrow = { fg = c.blue, bg = "NONE" },
    typescriptInterfaceHeritage = { fg = c.blueGreen, bg = "NONE" },
    typescriptInterfaceName = { fg = c.blueGreen, bg = "NONE" },
    typescriptInterfaceKeyword = { fg = c.blue, bg = "NONE" },
    typescriptInterfaceExtends = { fg = c.blue, bg = "NONE" },
    typescriptGlobal = { fg = c.blueGreen, bg = "NONE" },
    typescriptAsyncFuncKeyword = { fg = c.blue, bg = "NONE" },
    typescriptFuncKeyword = { fg = c.blue, bg = "NONE" },
    typescriptGlobalMethod = { fg = c.yellow, bg = "NONE" },
    typescriptPromiseMethod = { fg = c.yellow, bg = "NONE" },

    -- XML
    xmlTag = { fg = c.blue, bg = "NONE" },
    xmlTagName = { fg = c.blue, bg = "NONE" },
    xmlEndTag = { fg = c.blue, bg = "NONE" },

    -- Python
    pythonStatement = { fg = c.blue, bg = "NONE" },
    pythonOperator = { fg = c.blue, bg = "NONE" },
    pythonException = { fg = c.pink, bg = "NONE" },
    pythonExClass = { fg = c.blueGreen, bg = "NONE" },
    pythonBuiltinObj = { fg = c.lightBlue, bg = "NONE" },
    pythonBuiltinType = { fg = c.blueGreen, bg = "NONE" },
    pythonBoolean = { fg = c.blue, bg = "NONE" },
    pythonNone = { fg = c.blue, bg = "NONE" },
    pythonTodo = { fg = c.blue, bg = "NONE" },
    pythonClassVar = { fg = c.blue, bg = "NONE" },
    pythonClassDef = { fg = c.blueGreen, bg = "NONE" },

    -- TeX
    texStatement = { fg = c.blue, bg = "NONE" },
    texBeginEnd = { fg = c.yellow, bg = "NONE" },
    texBeginEndName = { fg = c.lightBlue, bg = "NONE" },
    texOption = { fg = c.lightBlue, bg = "NONE" },
    texBeginEndModifier = { fg = c.lightBlue, bg = "NONE" },
    texDocType = { fg = c.pink, bg = "NONE" },
    texDocTypeArgs = { fg = c.lightBlue, bg = "NONE" },

    -- Git
    gitcommitHeader = { fg = c.gray, bg = "NONE" },
    gitcommitOnBranch = { fg = c.gray, bg = "NONE" },
    gitcommitBranch = { fg = c.pink, bg = "NONE" },
    gitcommitComment = { fg = c.gray, bg = "NONE" },
    gitcommitSelectedType = { fg = c.green, bg = "NONE" },
    gitcommitSelectedFile = { fg = c.green, bg = "NONE" },
    gitcommitDiscardedType = { fg = c.red, bg = "NONE" },
    gitcommitDiscardedFile = { fg = c.red, bg = "NONE" },
    gitcommitOverflow = { fg = c.red, bg = "NONE" },
    gitcommitSummary = { fg = c.pink, bg = "NONE" },
    gitcommitBlank = { fg = c.pink, bg = "NONE" },

    -- Lua
    luaFuncCall = { fg = c.yellow, bg = "NONE" },
    luaFuncArgName = { fg = c.lightBlue, bg = "NONE" },
    luaFuncKeyword = { fg = c.pink, bg = "NONE" },
    luaLocal = { fg = c.pink, bg = "NONE" },
    luaBuiltIn = { fg = c.blue, bg = "NONE" },

    -- SH
    shDeref = { fg = c.lightBlue, bg = "NONE" },
    shVariable = { fg = c.lightBlue, bg = "NONE" },

    -- SQL
    sqlKeyword = { fg = c.pink, bg = "NONE" },
    sqlFunction = { fg = c.yellowOrange, bg = "NONE" },
    sqlOperator = { fg = c.pink, bg = "NONE" },

    -- YAML
    yamlKey = { fg = c.blue, bg = "NONE" },
    yamlConstant = { fg = c.blue, bg = "NONE" },
}
set_highlights(languages)
