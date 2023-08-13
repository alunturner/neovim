--!structure: vim options

local options = {
	-- Tabs
	expandtab = true,                 -- Use spaces by default
	shiftwidth = 4,                   -- Set amount of space characters, when we press "<" or ">"
	tabstop = 4,                      -- 1 tab equal 2 spaces
	smartindent = true,               -- Turn on smart indentation

	-- Clipboard 
	clipboard = 'unnamedplus',        -- Use system clipboard
	fixeol = false,                   -- Turn off appending new line in the end of a file

	-- Search
	ignorecase = true,                -- Ignore case if all characters in lower case
	joinspaces = false,               -- Join multiple spaces in search
	smartcase = true,                 -- When there is a one capital letter search for exact match
	showmatch = true,                 -- Highlight search instances

	-- Window
	splitbelow = true,                -- Put new windows below current
	splitright = true,                -- Put new vertical splits to right

	-- Wild Menu 
	wildmenu = true,                  -- Tab autocomplete for commands in the bottom bar
	wildmode = "longest:full,full",

	-- Appearance
	wrap = false,                     -- Turn word wrap off
	termguicolors = true,             -- Use plenty of colours
	number = true,                    -- Show line numbers
	relativenumber = true,            -- Show relative line numbers
	scrolloff = 8,                  -- Scroll when cursor is within eight lines of top/bottom
}

-- Set options from table
for option, val in pairs(options) do
	vim.opt[option] = val
end