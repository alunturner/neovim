--!structure: load autocommands in lua 

local Util = {}

-- function to create a list of commands and turn them to autocommands
-- https://www.jmaguire.tech/posts/treesitter_folding/
Util.create_augroups = function(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command("augroup "..group_name)
        vim.api.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten({"autocmd", def}), " ")
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command("augroup END")
    end
end

return Util
