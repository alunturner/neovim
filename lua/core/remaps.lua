local map = require("utils.keys").map

-- Allow VSCode style shifting around of lines
map("v", "J", ":m '>+1<CR>gv=gv", "Shift line(s) down")
map("v", "K", ":m '<-2<CR>gv=gv", "Shift line(s) up")

-- Quick way to remove highlighting
map("n", "<Esc>", "<cmd>nohl<cr>", "Clear highlights")

-- Keep cursor centred when moving the screen
map("n", "<C-d>", "<C-d>zz", "Centre cursor after move")
map("n", "<C-u>", "<C-u>zz", "Centre cursor after move")

-- Window navigation
map("n", "<C-h>", "<C-w>h", "Move to window on left")
map("n", "<C-j>", "<C-w>j", "Move to window below")
map("n", "<C-k>", "<C-w>k", "Move to window above")
map("n", "<C-l>", "<C-w>l", "Move to window on right")
