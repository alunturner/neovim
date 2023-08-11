--[[
    Doc: Utils for mapping keys
]]

local M = {}

-- Map a key for a mode from left to right with a description
M.map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Set the leader key as leader and local leader, disabling the key in normal and visual modes
M.set_leader = function(key)
	vim.g.mapleader = key
	vim.g.maplocalleader = key
	M.map({ "n", "v" }, key, "<nop>")
end

return M
