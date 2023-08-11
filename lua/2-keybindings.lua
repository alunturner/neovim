--[[
  File: 2-keybindings.lua
  Description: Number indicates order of execution in init.lua. Keybindings for plugins and other remaps.
]]

local map = require("helpers.keys").map

vim.g.mapleader = ' '                                                                 -- Use space as <leader>
-- TODO check and verify mappings 
-- LSP
map('n', 'K', '<cmd>lua vim.lsp.buf.hover<CR>', 'description')                                      -- Hover object
map('n', 'ga', '<cmd>lua vim.lsp.buf.code_action<CR>', 'description')                                -- Code actions
map('n', 'gR', '<cmd>lua vim.lsp.buf.rename<CR>', 'description')                                     -- Rename an object
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration<cr>', 'description')                                -- Go to declaration

-- TODO check and verify mappings 
-- Telescope
map('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', 'description')                                    -- Goto declaration
map('n', '<leader>p', '<cmd>Telescope oldfiles<CR>', 'description')                                    -- Show recent files
map('n', '<leader>O', '<cmd>Telescope git_files<CR>', 'description')                                   -- Search for a file in project
map('n', '<leader>o', '<cmd>Telescope find_files<CR>', 'description')                                  -- Search for a file (ignoring git-ignore)
map('n', '<leader>i', '<cmd>Telescope jumplist<CR>', 'description')                                    -- Show jumplist (previous locations)
map('n', '<leader>b', '<cmd>Telescope git_branches<CR>', 'description')                                -- Show git branches
map('n', '<leader>f', '<cmd>Telescope live_grep<CR>', 'description')                                   -- Find a string in project
map('n', '<leader>q', '<cmd>Telescope buffers<CR>', 'description')                                     -- Show all buffers
map('n', '<leader>a', '<cmd>Telescope<CR>', 'description')                                             -- Show all commands
map('n', '<leader>t', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', 'description')               -- Search for dynamic symbols

-- TODO check and verify mappings 
-- Trouble
map('n', '<leader>x', '<cmd>TroubleToggle<CR>', 'description')                                         -- Show all problems in project (with help of LSP)
map('n', 'gr', '<cmd>Trouble lsp_references<CR>', 'description')                                       -- Show use of object in project

-- Neo Tree
map('n', '<leader>v', '<cmd>NeoTreeFocusToggle<CR>', 'description')                                        -- Toggle file explorer

-- Loader
map('n', '<leader>L', '<cmd>Lazy show', 'description')                                                 -- to keep everything together,
