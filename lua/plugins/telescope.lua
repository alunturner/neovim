--!structure::fuzzy finder

local Plugin = {
    "nvim-telescope/telescope.nvim", --!uses::telescope
    branch = "0.1.x",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim"
    },
}

Plugin.config = function()
    require("telescope").setup({
        defaults = {
            mappings = {
                i = {
                    ["<C-j>"] = "move_selection_next",
                    ["<C-k"] = "move_selection_previous",
                },
            },
        },
        extensions = {
            file_browser = {
                theme = "dropdown",
                hijack_netrw = true,
            },
        },
    })

    local map = require("utils.keys").map
    local builtin = require("telescope.builtin")
    require("telescope").load_extension("file_browser");

    map("n", "<leader>ff", builtin.find_files, "[f]ind [f]ile")
    map("n", "<leader>fs", builtin.live_grep, "[f]ind [s]tring")
    map("n", "<leader>fc", builtin.grep_string, "[f]ind at [c]ursor")
    map("n", "<leader>fo", builtin.lsp_document_symbols, "[f]ind [o]bject in buffer")
    map("n", "<leader>fO", builtin.lsp_dynamic_workspace_symbols, "[f]ind [O]bject in repo")
    map("n", "<leader>fh", builtin.help_tags, "[f]ind [h]elp")
    map("n", "<leader>fgc", builtin.git_commits, "[f]ind [g]it [c]ommit")
    map("n", "<leader>fgb", builtin.git_branches, "[f]ind [g]it [b]ranch")
    map("n", "<leader>fr", builtin.lsp_references, "[f]ind [r]eferences")
end

return { Plugin }
