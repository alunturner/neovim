--!structure: per file type formatting rules
--!uses: formatter::mhartington/formatter.nvim_

local Plugin = {
    "mhartington/formatter.nvim",
    lazy = false,
}

Plugin.config = function()
    require("formatter").setup({
        filetype = {
            -- Formatter configurations for filetype "lua" go here
            -- and will be executed in order
            lua = {
                -- "formatter.filetypes.lua" defines default configurations for the
                -- "lua" filetype
                require("formatter.filetypes.lua").stylua,

                -- You can also define your own configuration
                function()
                    -- Supports conditional formatting
                    if util.get_current_buffer_file_name() == "special.lua" then
                        return nil
                    end

                    -- Full specification of configurations is down below and in Vim help
                    -- files
                    return {
                        exe = "stylua",
                        args = {
                            "--search-parent-directories",
                            "--stdin-filepath",
                            util.escape_path(util.get_current_buffer_file_path()),
                            "--",
                            "-",
                        },
                        stdin = true,
                    }
                end
            },
            -- Use the special "*" filetype for defining formatter configurations on
            -- any filetype
            ["*"] = {
                -- "formatter.filetypes.any" defines default configurations for any
                -- filetype
                require("formatter.filetypes.any").remove_trailing_whitespace
            }
        }
    })
end

return {Plugin}











