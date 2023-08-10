--[[
  File: init.lua
  Description: Entry point file for neovim
  Info: Use <zo> and <zc> to open and close foldings
]]

-- Bootstrap plugin manager
require "0-bootstrap-lazy"

-- Settings
require "1-settings"
require "2-keybindings"

-- Plugin management {{{
local lazy = require("lazy")
lazy.setup("plugins")
-- }}}

-- vim:tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=0 foldlevel=0
