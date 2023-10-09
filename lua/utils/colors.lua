local Util = {}

Util.set_highlights = function(highlights)
    for hl_name, hl_val in pairs(highlights) do
        vim.api.nvim_set_hl(0, hl_name, hl_val)
    end
end

return Util
