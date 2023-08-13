--!structure: vim remappings

local map = require("utils.keys").map

-- Plugins
map("n", "<leader>L", "<cmd>Lazy show<CR>", "Show the package manager")

-- Quick way to remove highlighting
map("n", "<leader>h", "<cmd>nohl<cr>", "Clear highlights")

-- Window navigation
map("n", "<C-h>", "<C-w><C-h>", "Navigate windows to the left")
map("n", "<C-j>", "<C-w><C-j>", "Navigate windows down")
map("n", "<C-k>", "<C-w><C-k>", "Navigate windows up")
map("n", "<C-l>", "<C-w><C-l>", "Navigate windows to the right")

-- Buffer navigation
map("n", "<leader>bb", "<cmd>:bprevious<cr>", "[b]uffer [b]ack")
map("n", "<leader>bn", "<cmd>:bnext<cr>", "[b]uffer [n]ext")
