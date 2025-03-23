return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostic = {
				severity_sort = true,
				float = {
					header = "",
					border = "rounded",
				},
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
          numhl = {
						[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
						[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          }
				} or {},
				virtual_text = false,
			},
		},
		-- Opts table gets automatically passed into config function. If we did not define config function,
		-- it gets passed into setup function.
		config = function(_, opts)
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			vim.diagnostic.config(opts.diagnostic)

			-- x is visual mode, v is visual mode and select mode. See :help Select-mode
			vim.keymap.set({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Show code actions" })

			-- Diagnostics
			vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
			vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

			vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "Goto definition" })
			vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "Goto references" })
		end,
	},
}
