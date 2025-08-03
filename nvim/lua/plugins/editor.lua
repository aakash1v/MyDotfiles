-- plugins/editor.lua

return {
	-- Autoformatter plugin
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					bash = { "shfmt" },
					python = { "black" },
					sh = { "shfmt" },
				},
				format_on_save = false,
			})

			-- Keymap for manual formatting
			vim.keymap.set("n", "<leader>f", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format file" })
		end,
	},

	-- Treesitter-based folding support
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			require("ufo").setup()
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			vim.o.foldmethod = "expr"
			vim.o.foldexpr = "nvim_treesitter#foldexpr()"
			vim.keymap.set("n", "<Tab>", "za", { desc = "Toggle fold" })
		end,
	},

	-- Word wrap settings
	{
		"nvim-lua/plenary.nvim", -- dummy plugin to run setup
		config = function()
			vim.o.wrap = true
			vim.o.linebreak = true
			vim.o.breakindent = true
		end,
	},
}
