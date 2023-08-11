--[[
    Doc: Setup loader, load plugins
    Ref: (lazy.nvim)[https://github.com/folke/lazy.nvim] 
]]

-- Install lazy if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- We have to set the leader key before loading plugins
local keys = require("helpers.keys")
keys.set_leader(" ")

-- Use a protected call so we don't error out on first use
local ok,lazy = pcall(require, "lazy")
if not ok then
    return
end

-- Load plugins from specifications
lazy.setup("plugins")
