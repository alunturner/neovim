--[[
  File: init.lua
  Description: Entry point file for neovim
  Info: Use <zo> and <zc> to open and close foldings
]]

-- Bootstrap plugin manager
require "0-bootstrap-lazy"

-- Apply settings and bindings
require "1-settings"
require "2-keybindings"

-- Setup plugins
local lazy = require("lazy")
lazy.setup("plugins")
