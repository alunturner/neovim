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
    scrolloff = 5,
    sidescrolloff = 5,
    colorcolumn = "80",
    signcolumn = "yes",

    -- Cursor display
    cursorline = true,

    -- Numbers
    number = true,

    -- Theme display
    termguicolors = true,

    -- Backup
    undofile = true,
    updatetime = 500,

    -- Mapped sequence timing
    timeoutlen = 500,

    -- Statusline global, command line on but don't show mode
    laststatus = 3,
    cmdheight = 1,
    showmode = false,

    -- Misc
    jumpoptions = "stack",
}

-- set options from table
for option, val in pairs(options) do
    vim.opt[option] = val
end
