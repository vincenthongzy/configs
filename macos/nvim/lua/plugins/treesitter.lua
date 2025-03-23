return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context"
	},
	build = ":TSUpdate",
	config = function()
    require("treesitter-context").setup({
      enable = true
    })
    vim.keymap.set("n","[c", function()
      require("treesitter-context").go_to_context(vim.v.count1)
    end)
		local config = require("nvim-treesitter.configs")

		config.setup({
			ensure_installed = { "lua", "typescript", "javascript" },
			highlight = { enable = true },
			indent = { enable = true },
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["ak"] = "@comment.outer",
						["aa"] = "@parameter.inner", -- "ap" is already used
						["ia"] = "@parameter.outer", -- "ip" is already used
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					keymaps = {
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
							["]k"] = "@comment.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
							["]K"] = "@comment.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
							["[k"] = "@comment.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
							["[K"] = "@comment.outer",
						},
					},
				},
				lsp_interop = {
					enable = true,
					border = "rounded",
					peek_definition_code = {
						["gpof"] = "@function.outer",
						["gpoc"] = "@class.outer",
					},
				},
			},
		})
	end,
}
