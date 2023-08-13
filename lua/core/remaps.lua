--!structure: vim remappings

local map = require("utils.keys").map

map("n", "<leader>L", "<cmd>Lazy show<CR>", "Show the package manager")
