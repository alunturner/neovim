--!structure: fuzzy finder
--!uses: telescope::nvim-telescope/telescope.nvim

local Plugin = {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
}

Plugin.config = function ()
    require("telescope").setup({
        defaults = {
            mappings = {
                i = {
                    ["<C-j>"] = "move_selection_next",
                    ["<C-k"] = "move_selection_previous",
                    ["<Esc>"] = "close",
                }
            }
        }
    })

    local map = require("utils.keys").map
    local builtin = require('telescope.builtin')

    map('n', '<leader>ff', builtin.find_files, "[f]ind [f]ile")
    map('n', '<leader>fs', builtin.live_grep, "[f]ind [s]tring")
    map("n", "<leader>fc", builtin.grep_string, "[f]ind at [c]ursor")
    map("n", "<leader>fo", builtin.lsp_document_symbols, "[f]ind [o]bject")
    map("n", "<leader>fh", builtin.help_tags, "[f]ind [h]elp")
end

return { Plugin }
