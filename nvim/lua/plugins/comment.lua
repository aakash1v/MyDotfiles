return {
	"numToStr/Comment.nvim",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	opts = {
		pre_hook = function(ctx)
			local U = require("Comment.utils")

			-- Use context_commentstring for tsx/jsx
			if ctx.ctype == U.ctype.block or ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.line then
				require("ts_context_commentstring.internal").update_commentstring()
			end
		end,
	},
	config = function(_, opts)
		require("Comment").setup(opts)

		-- Normal mode Ctrl-/
		vim.keymap.set("n", "<C-_>", function()
			require("Comment.api").toggle.linewise.current()
		end, { desc = "Toggle comment (Ctrl-/)", noremap = true })

		-- Visual mode Ctrl-/
		vim.keymap.set("v", "<C-_>", function()
			local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
			vim.api.nvim_feedkeys(esc, "nx", false)
			require("Comment.api").toggle.linewise(vim.fn.visualmode())
		end, { desc = "Toggle comment (Ctrl-/)", noremap = true })
	end,
}
