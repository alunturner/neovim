--[[
  File: mason.lua
  Description: Mason plugin configuration (with lspconfig)
  See: https://github.com/williamboman/mason.nvim
]]

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",             -- Lua 
    "tsserver",           -- Typescript and Javascript
    "emmet_ls",           -- Emmet (Vue, HTML, CSS)
    "cssls",              -- CSS
    "rust_analyzer",      -- Rust
    "eslint"              -- ESLint
  },
  automatic_installation = true
});

-- Individual lsp config can be added here
mason_lspconfig.setup_handlers {
  function (server_name)
    lspconfig[server_name].setup {}
  end,
}
