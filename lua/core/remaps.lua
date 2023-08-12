--!structure: contains vim remappings

local map = require("helpers.keys").map

map('n', '<leader>L', '<cmd>Lazy show<CR>', 'Show the package manager')

-- TODO check and move to plugins
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

-- TODO check and move to plugins
-- Neo Tree
map('n', '<leader>v', '<cmd>NeoTreeFocusToggle<CR>', 'description')                                        -- Toggle file explorer


