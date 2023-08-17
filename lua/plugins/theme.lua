--!structure::colour theme

local Plugin = {
    "rockyzhang24/arctic.nvim", --!uses::arctic
    dependencies = { "rktjmp/lush.nvim" },
    branch = "main",
    priority = 1000,
}

Plugin.config = function()
    vim.cmd("colorscheme arctic")
end

return { Plugin }
