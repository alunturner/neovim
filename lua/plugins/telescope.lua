local Plugin = {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
    },
}

Plugin.config = function()
    require("telescope").setup({
        extensions = {
            file_browser = {
                theme = "dropdown",
                hijack_netrw = true,
            },
        },
    })

    local map = require("utils.keys").map
    local builtin = require("telescope.builtin")
    require("telescope").load_extension("file_browser")

    -- Builtins
    map("n", "<leader>ff", builtin.find_files, "[f]ind [f]ile")
    map("n", "<leader>fs", builtin.live_grep, "[f]ind [s]tring")
    map("n", "<leader>fc", builtin.grep_string, "[f]ind at [c]ursor")
    map("n", "<leader>fh", builtin.help_tags, "[f]ind [h]elp")

    -- TODO: move over to only use Telescope for the lsp stuff for consistency
    -- LSP
    map("n", "<leader>fo", builtin.lsp_document_symbols, "[f]ind [o]bject in buffer")
    map("n", "<leader>fO", builtin.lsp_dynamic_workspace_symbols, "[f]ind [O]bject in repo")
    map("n", "<leader>fr", builtin.lsp_references, "[f]ind [r]eferences")

    -- Plugins
    map("n", "<leader>e", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", "[e]xplore files")
end

return { Plugin }
