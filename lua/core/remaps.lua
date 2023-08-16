--!structure::vim remappings

local map = require("utils.keys").map

-- Plugins
map("n", "<leader>L", "<cmd>Lazy show<CR>", "Show the [L]oader")

-- Allow VSCode style shifting around of lines
map("v", "J", ":m '>+1<CR>gv=gv", "Shift line(s) down")
map("v", "K", ":m '<-2<CR>gv=gv", "Shift line(s) up")

-- Quick way to remove highlighting
map("n", "<Esc>", "<cmd>nohl<cr>", "Clear highlights")

-- Buffer navigation
map("n", "<leader>bp", "<cmd>:bprevious<cr>", "[b]uffer [p]revious")
map("n", "<leader>bn", "<cmd>:bnext<cr>", "[b]uffer [n]ext")

-- Diagnostic navigation
map("n", "<leader>dp", vim.diagnostic.goto_prev, "[d]iagnostic [p]revious")
map("n", "<leader>dn", vim.diagnostic.goto_next, "[d]iagnostic [n]ext")

-- Keep cursor centred when moving the screen
map("n", "<C-d>", "<C-d>zz", "Centre cursor after move")
map("n", "<C-u>", "<C-u>zz", "Centre cursor after move")

-- Window navigation
map("n", "<C-h>", "<C-w>h", "Move to window on left")
map("n", "<C-j>", "<C-w>j", "Move to window below")
map("n", "<C-k>", "<C-w>k", "Move to window above")
map("n", "<C-l>", "<C-w>l", "Move to window on right")
