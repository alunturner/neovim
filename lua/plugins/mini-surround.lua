local Plugin = {
	"echasnovski/mini.surround",
	version = "*",
}

Plugin.config = function()
	require("mini.surround").setup()
end

return { Plugin }
