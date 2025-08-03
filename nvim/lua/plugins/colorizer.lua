return {
	"NvChad/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		filetypes = { "*", "!lazy" }, -- apply to all files except lazy.nvim UI
		user_default_options = {
			RGB = true,
			RRGGBB = true,
			names = true, -- "red", "blue", etc
			css = true,
			css_fn = true, -- rgb(), hsl(), etc.
			mode = "background", -- can be 'background', 'foreground', or 'virtualtext'
		},
	},
}
