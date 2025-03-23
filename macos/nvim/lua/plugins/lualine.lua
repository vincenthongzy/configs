return {
	"nvim-lualine/lualine.nvim",
	config = function()
    -- this theme is defined in flexoki repo
    local custom_flexoki = require("lualine.themes.flexoki")
    local p = require("flexoki.palette")

		require("lualine").setup({
			options = {
				globalstatus = true,
				theme = custom_flexoki,
        component_separators = '',
			},
			sections = {
				lualine_a = { { "mode", separator = { left = "" } }},
				-- lualine_a = nil,
				lualine_b = {
					{
						"branch",
            draw_empty = true,
						separator = {
							right = "",
						},
					},
				-- 	{
				-- 		"diff",
				-- 	},
				-- 	{
				-- 		"diagnostics",
				-- 	},
				},
				lualine_c = { "diff", "diagnostics", "filename" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = { { "location", separator = {left="", right = ""}}},
			},
		})
	end,
}
