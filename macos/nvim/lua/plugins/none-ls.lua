return {
	"nvimtools/none-ls.nvim",
	dependencies = {
    -- eslint_d now lives in this repo
    -- https://github.com/nvimtools/none-ls.nvim/issues/58
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
        require('none-ls.diagnostics.eslint_d'),
			},
		})

		vim.keymap.set("v", "<leader>lf", vim.lsp.buf.format, { desc = "Format selected lines" })
		vim.keymap.set("n", "<leader>lF", vim.lsp.buf.format, { desc = "Format whole file" })
	end,
}
