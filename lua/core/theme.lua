-- PAX scheme, influenced heavily by the vs code dark plus theme,
-- shamelessly pillaged from Mofiqul vscode.nvim repo

-- CONFIG
local use_italic_comments = true

-- COLORS
-- TODO see if there is any consolidation that can be done here (if we have repeated of any
-- strings, also we have a mixture of cases)
local colors = {
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

    statusPurple = "#541067", -- status bar (not in a folder)
    statusRed = "#f44747",
    statusGreen = "#354a2c", -- outer edge of a comment
    statusBlue = "#0c64c1", -- status bar (in a folder)
    statusLightBlue = "#5CB6F8",
    statusYellow = "#ffaf00",
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
local function set_highlights(highlights)
    for hl_name, hl_val in pairs(highlights) do
        vim.api.nvim_set_hl(0, hl_name, hl_val)
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
    ColorColumn = { bg = c.cursorDarkDark },
    Cursor = { fg = c.cursorDark, bg = c.cursorLight },
    CursorLine = { bg = c.cursorDarkDark },
    CursorColumn = { bg = c.cursorDarkDark },
    Directory = { fg = c.blue, bg = c.back },
    DiffAdd = { bg = c.diffGreenLight },
    DiffChange = { bg = c.diffRedDark },
    DiffDelete = { bg = c.diffRedLight },
    DiffText = { bg = c.diffRedLight },
    EndOfBuffer = { fg = c.back },
    ErrorMsg = { fg = c.red, bg = c.back },
    VertSplit = { fg = c.splitDark, bg = c.back },
    Folded = { bg = c.foldBackground },
    FoldColumn = { fg = c.lineNumber, bg = c.back },
    SignColumn = { bg = c.back },
    IncSearch = { bg = c.searchCurrent },
    LineNr = { fg = c.lineNumber, bg = c.back },
    CursorLineNr = { fg = c.popupFront, bg = c.back },
    MatchParen = { bg = c.cursorDark },
    ModeMsg = { fg = c.front, bg = c.leftDark },
    MoreMsg = { fg = c.front, bg = c.leftDark },
    NonText = { fg = c.lineNumber },
    Pmenu = { fg = c.popupFront, bg = c.popupBack },
    PmenuSel = { fg = c.popupFront, bg = c.popupHighlightBlue },
    PmenuSbar = { bg = c.popupHighlightGray },
    PmenuThumb = { bg = c.popupFront },
    Question = { fg = c.blue, bg = c.back },
    Search = { bg = c.search },
    SpecialKey = { fg = c.blue },
    StatusLine = { fg = c.front, bg = c.leftMid },
    StatusLineNC = { fg = c.front, bg = c.leftDark },
    TabLine = { fg = c.front, bg = c.tabOther },
    TabLineFill = { fg = c.front, bg = c.tabOutside },
    TabLineSel = { fg = c.front, bg = c.tabCurrent },
    Title = { bold = true },
    Visual = { bg = c.selection },
    VisualNOS = { bg = c.selection },
    WarningMsg = { fg = c.red, bg = c.back, bold = true },
    WildMenu = { bg = c.selection },
    Comment = { fg = c.green, italic = use_italic_comments },
    Constant = { fg = c.blue },
    String = { fg = c.orange },
    Character = { fg = c.orange },
    Number = { fg = c.lightGreen },
    Boolean = { fg = c.blue },
    Float = { fg = c.lightGreen },
    Identifier = { fg = c.lightBlue },
    Function = { fg = c.yellow },
    Statement = { fg = c.pink },
    Conditional = { fg = c.pink },
    Repeat = { fg = c.pink },
    Label = { fg = c.pink },
    Operator = { fg = c.front },
    Keyword = { fg = c.pink },
    Exception = { fg = c.pink },
    PreProc = { fg = c.pink },
    Include = { fg = c.pink },
    Define = { fg = c.pink },
    Macro = { fg = c.pink },
    Type = { fg = c.blue },
    StorageClass = { fg = c.blue },
    Structure = { fg = c.blueGreen },
    Typedef = { fg = c.blue },
    Special = { fg = c.yellowOrange },
    SpecialChar = { fg = c.front },
    Tag = { fg = c.front },
    Delimiter = { fg = c.front },
    SpecialComment = { fg = c.green },
    Debug = { fg = c.front },
    Underlined = { underline = true },
    Conceal = { fg = c.front, bg = c.back },
    Ignore = { fg = c.front },
    Error = { fg = c.red, bg = c.back, undercurl = true, sp = c.vscRed },
    Todo = { fg = c.yellowOrange, bg = c.back, bold = true },
    SpellBad = { fg = c.red, bg = c.back, undercurl = true, sp = c.vscRed },
    SpellCap = { fg = c.red, bg = c.back, undercurl = true, sp = c.vscRed },
    SpellRare = { fg = c.red, bg = c.back, undercurl = true, sp = c.vscRed },
    SpellLocal = { fg = c.red, bg = c.back, undercurl = true, sp = c.vscRed },
    Whitespace = { fg = c.lineNumber },

    -- LSP
    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.yellow },
    DiagnosticInfo = { fg = c.blue },
    DiagnosticHint = { fg = c.blue },
    DiagnosticUnderlineError = { undercurl = true, sp = c.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.blue },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.blue },
    LspReferenceText = { bg = c.popupHighlightGray },
    LspReferenceRead = { bg = c.popupHighlightGray },
    LspReferenceWrite = { bg = c.popupHighlightGray },
    -- find out if this is an internal, I think it probably is, or perhaps
    -- it is used by nvim lsp config? who knows
    LspFloatWinNormal = { fg = c.front },
    LspFloatWinBorder = { fg = c.lineNumber },

    -- Legacy groups for official git.vim and diff.vim syntax
    diffAdded = { link = "DiffAdd" },
    diffChanged = { link = "DiffChange" },
    diffRemoved = { link = "DiffDelete" },
}
set_highlights(builtins)

local plugins = {
    -- Treesitter
    ["@error"] = { fg = c.red },
    ["@punctuation.bracket"] = { fg = c.front },
    ["@punctuation.special"] = { fg = c.front },
    ["@comment"] = { fg = c.green, italic = use_italic_comments },
    ["@constant"] = { fg = c.accentBlue },
    ["@constant.builtin"] = { fg = c.blue },
    ["@constant.macro"] = { fg = c.blueGreen },
    ["@string.regex"] = { fg = c.orange },
    ["@string"] = { fg = c.orange },
    ["@character"] = { fg = c.orange },
    ["@number"] = { fg = c.lightGreen },
    ["@boolean"] = { fg = c.blue },
    ["@float"] = { fg = c.lightGreen },
    ["@annotation"] = { fg = c.yellow },
    ["@attribute"] = { fg = c.yellow },
    ["@attribute.builtin"] = { fg = c.blueGreen },
    ["@namespace"] = { fg = c.blueGreen },
    ["@function.builtin"] = { fg = c.yellow },
    ["@function"] = { fg = c.yellow },
    ["@function.macro"] = { fg = c.yellow },
    ["@parameter"] = { fg = c.lightBlue },
    ["@parameter.reference"] = { fg = c.lightBlue },
    ["@method"] = { fg = c.yellow },
    ["@field"] = { fg = c.lightBlue },
    ["@property"] = { fg = c.lightBlue },
    ["@constructor"] = { fg = c.blueGreen },
    ["@conditional"] = { fg = c.pink },
    ["@repeat"] = { fg = c.pink },
    ["@label"] = { fg = c.lightBlue },
    ["@keyword"] = { fg = c.pink },
    ["@keyword.function"] = { fg = c.blue },
    ["@keyword.operator"] = { fg = c.blue },
    ["@operator"] = { fg = c.front },
    ["@exception"] = { fg = c.pink },
    ["@type"] = { fg = c.blueGreen },
    ["@type.builtin"] = { fg = c.blue },
    ["@type.qualifier"] = { fg = c.blue },
    ["@storageClass"] = { fg = c.blue },
    ["@structure"] = { fg = c.lightBlue },
    ["@include"] = { fg = c.pink },
    ["@variable"] = { fg = c.lightBlue },
    ["@variable.builtin"] = { fg = c.lightBlue },
    ["@text"] = { fg = c.front },
    ["@text.underline"] = { fg = c.yellowOrange },
    ["@tag"] = { fg = c.blue },
    ["@tag.delimiter"] = { fg = c.gray },
    ["@tag.attribute"] = { fg = c.lightBlue },
    ["@text.title"] = { fg = c.blue, bold = true },
    ["@text.literal"] = { fg = c.front },
    ["@text.literal.markdown"] = { fg = c.orange },
    ["@text.literal.markdown_inline"] = { fg = c.orange },
    ["@text.emphasis"] = { fg = c.front, italic = true },
    ["@text.strong"] = { fg = c.blue, bold = true },
    ["@text.uri"] = { fg = c.front },
    ["@textReference"] = { fg = c.orange },
    ["@punctuation.delimiter"] = { fg = c.front },
    ["@stringEscape"] = { fg = c.orange, bold = true },
    ["@text.note"] = { fg = c.blueGreen, bold = true },
    ["@text.warning"] = { fg = c.yellowOrange, bold = true },
    ["@text.danger"] = { fg = c.red, bold = true },
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
    ["@regexp"] = { fg = c.red },
    ["@decorator"] = { link = "Identifier" },

    -- Telescope
    TelescopePromptBorder = { fg = c.lineNumber },
    TelescopeResultsBorder = { fg = c.lineNumber },
    TelescopePreviewBorder = { fg = c.lineNumber },
    TelescopeNormal = { fg = c.front },
    TelescopeSelection = { fg = c.front, bg = c.popupHighlightBlue },
    TelescopeMultiSelection = { fg = c.front, bg = c.popupHighlightBlue },
    TelescopeMatching = { fg = c.mediumBlue, bold = true },
    TelescopePromptPrefix = { fg = c.front },

    -- ...Lualine?
    -- symbols-outline
    -- white fg and lualine blue bg
    FocusedSymbol = { fg = "#ffffff", bg = c.uiBlue },
    SymbolsOutlineConnector = { fg = c.lineNumber },
}
set_highlights(plugins)

local languages = {
    -- Markdown
    markdownBold = { fg = c.blue, bold = true },
    markdownCode = { fg = c.orange },
    markdownRule = { fg = c.blue, bold = true },
    markdownCodeDelimiter = { fg = c.front },
    markdownHeadingDelimiter = { fg = c.blue },
    markdownFootnote = { fg = c.orange },
    markdownFootnoteDefinition = { fg = c.orange },
    markdownUrl = { fg = c.front, underline = true },
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
    jsonKeyword = { fg = c.lightBlue },
    jsonEscape = { fg = c.yellowOrange },
    jsonNull = { fg = c.blue },
    jsonBoolean = { fg = c.blue },

    -- HTML
    htmlTag = { fg = c.gray },
    htmlEndTag = { fg = c.gray },
    htmlTagName = { fg = c.blue },
    htmlSpecialTagName = { fg = c.blue },
    htmlArg = { fg = c.lightBlue },

    -- CSS
    cssBraces = { fg = c.front },
    cssInclude = { fg = c.pink },
    cssTagName = { fg = c.yellowOrange },
    cssClassName = { fg = c.yellowOrange },
    cssPseudoClass = { fg = c.yellowOrange },
    cssPseudoClassId = { fg = c.yellowOrange },
    cssPseudoClassLang = { fg = c.yellowOrange },
    cssIdentifier = { fg = c.yellowOrange },
    cssProp = { fg = c.lightBlue },
    cssDefinition = { fg = c.lightBlue },
    cssAttr = { fg = c.orange },
    cssAttrRegion = { fg = c.orange },
    cssColor = { fg = c.orange },
    cssFunction = { fg = c.orange },
    cssFunctionName = { fg = c.orange },
    cssVendor = { fg = c.orange },
    cssValueNumber = { fg = c.orange },
    cssValueLength = { fg = c.orange },
    cssUnitDecorators = { fg = c.orange },
    cssStyle = { fg = c.lightBlue },
    cssImportant = { fg = c.blue },

    -- JavaScript
    jsVariableDef = { fg = c.lightBlue },
    jsFuncArgs = { fg = c.lightBlue },
    jsFuncBlock = { fg = c.lightBlue },
    jsRegexpString = { fg = c.lightRed },
    jsThis = { fg = c.blue },
    jsOperatorKeyword = { fg = c.blue },
    jsDestructuringBlock = { fg = c.lightBlue },
    jsObjectKey = { fg = c.lightBlue },
    jsGlobalObjects = { fg = c.blueGreen },
    jsModuleKeyword = { fg = c.lightBlue },
    jsClassDefinition = { fg = c.blueGreen },
    jsClassKeyword = { fg = c.blue },
    jsExtendsKeyword = { fg = c.blue },
    jsExportDefault = { fg = c.pink },
    jsFuncCall = { fg = c.yellow },
    jsObjectValue = { fg = c.lightBlue },
    jsParen = { fg = c.lightBlue },
    jsObjectProp = { fg = c.lightBlue },
    jsIfElseBlock = { fg = c.lightBlue },
    jsParenIfElse = { fg = c.lightBlue },
    jsSpreadOperator = { fg = c.lightBlue },
    jsSpreadExpression = { fg = c.lightBlue },

    -- Typescript
    typescriptLabel = { fg = c.lightBlue },
    typescriptExceptions = { fg = c.lightBlue },
    typescriptBraces = { fg = c.front },
    typescriptEndColons = { fg = c.lightBlue },
    typescriptParens = { fg = c.front },
    typescriptDocTags = { fg = c.blue },
    typescriptDocComment = { fg = c.blueGreen },
    typescriptLogicSymbols = { fg = c.lightBlue },
    typescriptImport = { fg = c.pink },
    typescriptBOM = { fg = c.lightBlue },
    typescriptVariableDeclaration = { fg = c.lightBlue },
    typescriptVariable = { fg = c.blue },
    typescriptExport = { fg = c.pink },
    typescriptAliasDeclaration = { fg = c.blueGreen },
    typescriptAliasKeyword = { fg = c.blue },
    typescriptClassName = { fg = c.blueGreen },
    typescriptAccessibilityModifier = { fg = c.blue },
    typescriptOperator = { fg = c.blue },
    typescriptArrowFunc = { fg = c.blue },
    typescriptMethodAccessor = { fg = c.blue },
    typescriptMember = { fg = c.yellow },
    typescriptTypeReference = { fg = c.blueGreen },
    typescriptTemplateSB = { fg = c.yellowOrange },
    typescriptArrowFuncArg = { fg = c.lightBlue },
    typescriptParamImpl = { fg = c.lightBlue },
    typescriptFuncComma = { fg = c.lightBlue },
    typescriptCastKeyword = { fg = c.lightBlue },
    typescriptCall = { fg = c.blue },
    typescriptCase = { fg = c.lightBlue },
    typescriptReserved = { fg = c.pink },
    typescriptDefault = { fg = c.lightBlue },
    typescriptDecorator = { fg = c.yellow },
    typescriptPredefinedType = { fg = c.blueGreen },
    typescriptClassHeritage = { fg = c.blueGreen },
    typescriptClassExtends = { fg = c.blue },
    typescriptClassKeyword = { fg = c.blue },
    typescriptBlock = { fg = c.lightBlue },
    typescriptDOMDocProp = { fg = c.lightBlue },
    typescriptTemplateSubstitution = { fg = c.lightBlue },
    typescriptClassBlock = { fg = c.lightBlue },
    typescriptFuncCallArg = { fg = c.lightBlue },
    typescriptIndexExpr = { fg = c.lightBlue },
    typescriptConditionalParen = { fg = c.lightBlue },
    typescriptArray = { fg = c.yellow },
    typescriptES6SetProp = { fg = c.lightBlue },
    typescriptObjectLiteral = { fg = c.lightBlue },
    typescriptTypeParameter = { fg = c.blueGreen },
    typescriptEnumKeyword = { fg = c.blue },
    typescriptEnum = { fg = c.blueGreen },
    typescriptLoopParen = { fg = c.lightBlue },
    typescriptParenExp = { fg = c.lightBlue },
    typescriptModule = { fg = c.lightBlue },
    typescriptAmbientDeclaration = { fg = c.blue },
    typescriptFuncTypeArrow = { fg = c.blue },
    typescriptInterfaceHeritage = { fg = c.blueGreen },
    typescriptInterfaceName = { fg = c.blueGreen },
    typescriptInterfaceKeyword = { fg = c.blue },
    typescriptInterfaceExtends = { fg = c.blue },
    typescriptGlobal = { fg = c.blueGreen },
    typescriptAsyncFuncKeyword = { fg = c.blue },
    typescriptFuncKeyword = { fg = c.blue },
    typescriptGlobalMethod = { fg = c.yellow },
    typescriptPromiseMethod = { fg = c.yellow },

    -- XML
    xmlTag = { fg = c.blue },
    xmlTagName = { fg = c.blue },
    xmlEndTag = { fg = c.blue },

    -- Python
    pythonStatement = { fg = c.blue },
    pythonOperator = { fg = c.blue },
    pythonException = { fg = c.pink },
    pythonExClass = { fg = c.blueGreen },
    pythonBuiltinObj = { fg = c.lightBlue },
    pythonBuiltinType = { fg = c.blueGreen },
    pythonBoolean = { fg = c.blue },
    pythonNone = { fg = c.blue },
    pythonTodo = { fg = c.blue },
    pythonClassVar = { fg = c.blue },
    pythonClassDef = { fg = c.blueGreen },

    -- TeX
    texStatement = { fg = c.blue },
    texBeginEnd = { fg = c.yellow },
    texBeginEndName = { fg = c.lightBlue },
    texOption = { fg = c.lightBlue },
    texBeginEndModifier = { fg = c.lightBlue },
    texDocType = { fg = c.pink },
    texDocTypeArgs = { fg = c.lightBlue },

    -- Git
    gitcommitHeader = { fg = c.gray },
    gitcommitOnBranch = { fg = c.gray },
    gitcommitBranch = { fg = c.pink },
    gitcommitComment = { fg = c.gray },
    gitcommitSelectedType = { fg = c.green },
    gitcommitSelectedFile = { fg = c.green },
    gitcommitDiscardedType = { fg = c.red },
    gitcommitDiscardedFile = { fg = c.red },
    gitcommitOverflow = { fg = c.red },
    gitcommitSummary = { fg = c.pink },
    gitcommitBlank = { fg = c.pink },

    -- Lua
    luaFuncCall = { fg = c.yellow },
    luaFuncArgName = { fg = c.lightBlue },
    luaFuncKeyword = { fg = c.pink },
    luaLocal = { fg = c.pink },
    luaBuiltIn = { fg = c.blue },

    -- SH
    shDeref = { fg = c.lightBlue },
    shVariable = { fg = c.lightBlue },

    -- SQL
    sqlKeyword = { fg = c.pink },
    sqlFunction = { fg = c.yellowOrange },
    sqlOperator = { fg = c.pink },

    -- YAML
    yamlKey = { fg = c.blue },
    yamlConstant = { fg = c.blue },
}
set_highlights(languages)

local pax = {
    -- PaxLines
    -- Modes
    PaxLinesModeNormal = { fg = c.back, bg = c.front },
    PaxLinesModePending = { fg = c.back, bg = c.front },
    PaxLinesModeVisual = { fg = c.front, bg = c.statusGreen },
    PaxLinesModeInsert = { fg = c.front, bg = c.statusBlue },
    PaxLinesModeReplace = { fg = c.front, bg = c.statusRed },
    PaxLinesModeCommand = { fg = c.front, bg = c.statusPurple },
    PaxLinesModeEx = { fg = c.front, bg = c.violet },
    PaxLinesModeSelect = { fg = c.front, bg = c.violet },
    PaxLinesModeOther = { fg = c.front, bg = c.statusYellow },
}
set_highlights(pax)
