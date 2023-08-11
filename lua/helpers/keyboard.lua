local Mod = {}

-- WIP bring these over from lazy nvim starter, tidy up the below
Mod.map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Alias for function, that set new keybindings
local map = vim.api.nvim_set_keymap

-- Normal mode keybinding setter
Mod.nm = function(key, command)
	map('n', key, command, {noremap = true})
end

-- Input mode keybinding setter
Mod.im = function(key, command)
	map('i', key, command, {noremap = true})
end

-- Visual mode keybinding setter
Mod.vm = function(key, command)
	map('v', key, command, {noremap = true})
end

-- Terminal mode keybinding setter
Mod.tm = function(key, command)
	map('t', key, command, {noremap = true})
end

return Mod
