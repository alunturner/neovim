-- Doc: Entry point    

-- Bootstrap plugin manager
--require "0-bootstrap-lazy"

-- Apply settings and bindings
--require "1-settings"
--require "2-keybindings"

-- Setup plugins
--require("lazy").setup("plugins")


--What we are aiming for
-- Run the loader, remaps, settings
require("core.loader")
require("core.remaps")
require("core.settings")

