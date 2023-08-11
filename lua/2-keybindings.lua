--[[
  File: 2-keybindings.lua
  Description: Number indicates order of execution in init.lua. Keybindings for plugins and other remaps.
]]

require "helpers/globals"
local nm = require("helpers.keyboard").nm

g.mapleader = ' '                                                                 -- Use space as <leader>
-- TODO check and verify mappings 
-- LSP
nm('K', '<cmd>lua vim.lsp.buf.hover()<CR>' )                                      -- Hover object
nm('ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')                                -- Code actions
nm('gR', '<cmd>lua vim.lsp.buf.rename()<CR>')                                     -- Rename an object
nm('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')                                -- Go to declaration

-- TODO check and verify mappings 
-- Telescope
nm('gd', '<cmd>Telescope lsp_definitions<CR>')                                    -- Goto declaration
nm('<leader>p', '<cmd>Telescope oldfiles<CR>')                                    -- Show recent files
nm('<leader>O', '<cmd>Telescope git_files<CR>')                                   -- Search for a file in project
nm('<leader>o', '<cmd>Telescope find_files<CR>')                                  -- Search for a file (ignoring git-ignore)
nm('<leader>i', '<cmd>Telescope jumplist<CR>')                                    -- Show jumplist (previous locations)
nm('<leader>b', '<cmd>Telescope git_branches<CR>')                                -- Show git branches
nm('<leader>f', '<cmd>Telescope live_grep<CR>')                                   -- Find a string in project
nm('<leader>q', '<cmd>Telescope buffers<CR>')                                     -- Show all buffers
nm('<leader>a', '<cmd>Telescope<CR>')                                             -- Show all commands
nm('<leader>t', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>')               -- Search for dynamic symbols

-- TODO check and verify mappings 
-- Trouble
nm('<leader>x', '<cmd>TroubleToggle<CR>')                                         -- Show all problems in project (with help of LSP)
nm('gr', '<cmd>Trouble lsp_references<CR>')                                       -- Show use of object in project

-- Neo Tree
nm('<leader>v', '<cmd>NeoTreeFocusToggle<CR>')                                        -- Toggle file explorer

-- Loader
nm('<leader>L', '<cmd>Lazy show')                                                 -- to keep everything together,
