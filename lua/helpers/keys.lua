--[[
    Doc: Utils for mapping keys
]]

local M = {}

-- WIP bring these over from lazy nvim starter, tidy up the below
M.map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

return M
