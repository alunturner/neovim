--!structure::vim options

local options = {
    -- Tabs vs Spaces
    expandtab = true,
    shiftwidth = 4,
    tabstop = 4,
    softtabstop = 4,
    smartindent = true,

    -- Clipboard
    clipboard = "unnamedplus",

    -- Search
    ignorecase = true,
    smartcase = true,
    showmatch = true,

    -- Window
    splitbelow = true,
    splitright = true,

    -- Text display
    breakindent = true,
    scrolloff = 8,
    colorcolumn = "120",
    signcolumn = "yes",

    -- Cursor display
    cursorline = true,

    -- Numbers
    number = true,
    relativenumber = true,

    -- Theme display
    termguicolors = true,

    -- Backup
    undofile = true,
    updatetime = 500,

    -- Mapped sequence timing
    timeoutlen = 500,

    -- Split config
    laststatus = 3
}

-- set options from table
for option, val in pairs(options) do
    vim.opt[option] = val
end
