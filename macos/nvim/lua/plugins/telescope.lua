-- https://github.com/nvim-telescope/telescope.nvim/issues/758
local changes_compared_to_main = function()
  local input = vim.fn.input("base branch: ", "origin/mainline")
	local previewers = require("telescope.previewers")
	local pickers = require("telescope.pickers")
	local sorters = require("telescope.sorters")
	local finders = require("telescope.finders")

	pickers
		.new({}, {
			results_title = "Changes compared to main",
			finder = finders.new_oneshot_job({
				"git",
				"diff",
				"--name-only",
				"--diff-filter=ACMR",
				-- "origin/main...", -- exclusive
				"origin/main",
			}, {}),
			sorter = sorters.get_fuzzy_file(),
			previewer = previewers.new_termopen_previewer({
				get_command = function(entry)
					return {
						"git",
						"diff",
						"--diff-filter=ACMR",
						-- "origin/main...",
						"origin/main",
						"--",
						entry.value,
					}
				end,
			}),
		})
		:find()
end

return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local actions = require("telescope.actions")
      require("telescope").load_extension("fzf")
			require("telescope").setup({
				defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = 'top'
          },
					mappings = {
						i = {
							-- By default it sends **unfiltered** items to quickfix list instead
							["<C-q>"] = function(...)
								actions.smart_send_to_qflist(...)
								actions.open_qflist(...)
							end,
							-- By defaukt is C-space, but macOS uses it to change input source
              -- https://github.com/nvim-telescope/telescope.nvim/issues/2201#issuecomment-2002365378
							["<C-f>"] = actions.to_fuzzy_refine,
						},
						n = {
							["<C-q>"] = function(...)
								actions.smart_send_to_qflist(...)
								actions.open_qflist(...)
							end,
							-- By default it is <Esc>, but I feel this is more ergonomic
							["<C-c>"] = actions.close,
						},
					},
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]ile" })
			vim.keymap.set("n", "<leader>ff", ":Telescope find_files cwd=", { desc = "[S]earch [F]ile" })
			vim.keymap.set("n", "<leader>st", builtin.live_grep, { desc = "[S]earch [T]ext via grep" })
			vim.keymap.set("n", "<leader>bf", builtin.buffers, { desc = "[B]uffer [F]ind" })
			vim.keymap.set("n", "<leader>gf", builtin.git_status, { desc = "[G]it status [F]ind" })
			vim.keymap.set("n", "<leader>Gf", function()
				changes_compared_to_main()
			end, { desc = "[G]it status [F]ind" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
}
