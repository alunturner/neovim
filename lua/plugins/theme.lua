--!structure: sets up and applies a theme 
--!uses: tokyodark::tiagovla/tokyodark.nvim

local Plugin = {
    "tiagovla/tokyodark.nvim",
    lazy = false,
}

Plugin.config = function ()
    vim.g.tokyodark_enable_italic_comment = true
    vim.g.tokyodark_enable_italic = true
    vim.cmd("color tokyodark")
end

return { Plugin }