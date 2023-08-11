return {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    config = function()
        vim.g.tokyodark_enable_italic_comment = true
        vim.g.tokyodark_enable_italic = true
        vim.cmd("color tokyodark")
    end
}