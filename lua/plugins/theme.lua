--!structure: colour theme
--!uses: tokyonight::folke/tokyonight.nvim

local Plugin = {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
}

Plugin.config = function ()
    vim.cmd.colorscheme("tokyonight-night")
end

return { Plugin }