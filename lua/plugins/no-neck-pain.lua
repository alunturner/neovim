--!structure::central layout

local Plugin = {
    "shortcuts/no-neck-pain.nvim",
    lazy = false,
}

Plugin.config = function()
    require("no-neck-pain").setup({
        autocmds = {
            enableOnVimEnter = true,
        },
        buffers = {
            wo = {
                fillchars = "eob: ",
            },
        },
    })
end

return { Plugin }
