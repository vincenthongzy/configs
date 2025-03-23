return {
  "nuvic/flexoki-nvim",
  name = "flexoki",
  config = function()
    local p = require("flexoki.palette")
    require("flexoki").setup({
      variant = "auto",
      highlight_groups = {
        -- highlight group for window-picker used by neotree. Reference: https://github.com/nuvic/flexoki-nvim/blob/c22a9322d7716be393fc1937082ee541cab27ffc/lua/flexoki.lua#L80
        WindowPickerStatusLine = { fg = p.subtle, bg = p.panel },
        WindowPickerStatusLineNC = { fg = p.muted, bg = p.panel, blend = 60 },
        -- TelescopeMatching = { fg = p.cyan_two },
        TelescopeSelection = { bg = p.highlight_med }
      }
    })
    vim.cmd("colorscheme flexoki")
  end
}
