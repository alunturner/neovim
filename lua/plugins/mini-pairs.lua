local Plugin = {
	"echasnovski/mini.pairs",
	version = "*",
}

Plugin.config = function()
	require("mini.pairs").setup()
end

return { Plugin }
