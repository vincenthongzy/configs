-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
lvim.plugins = {
  { "catppuccin/nvim", name = "catppuccin" },
  { "git@github.com:nvim-telescope/telescope-ui-select.nvim.git" }
}
-- override lvim defaults
-- monorepo support
lvim.builtin.project.patterns = {">Projects", ".git"}
-- custom keymaps
lvim.keys.insert_mode["jk"] = "<ESC>"
-- lsp
vim.diagnostic.config({
  virtual_text = false,
})
-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
-- lualine
lvim.builtin.lualine.sections.lualine_a = {
  'mode'
}
-- telescope
lvim.builtin.telescope.defaults.path_display = {
  "absolute"
}

lvim.builtin.telescope.pickers.find_files.previewer = nil

lvim.builtin.telescope.defaults.layout_strategy = "horizontal"

lvim.builtin.telescope.defaults.layout_config = {
  height = 0.90,
  width = 0.90,
  anchor = "CENTER",
  prompt_position = 'top'
}

lvim.builtin.telescope.defaults.file_ignore_patterns = {
  ".git/",
  "node_modules/*",
  ".yarn/"
}

lvim.builtin.telescope.defaults.results_title = 'Results'

require("telescope").load_extension("ui-select")
-- theme
local colors = require('catppuccin.palettes').get_palette('mocha')
local ucolors = require('catppuccin.utils.colors')
local telescope_prompt = ucolors.darken(colors.crust, 0.95, '#000000')
local telescope_results = ucolors.darken(colors.mantle, 0.95, '#000000')
local telescope_text = colors.text
local telescope_prompt_title = colors.sky
local telescope_preview_title = colors.teal
local lualine_bg = colors.mantle
require('catppuccin').setup({
  flavour = 'macchiato',
  highlight_overrides = {
    -- https://github.com/augustocdias/dotfiles/blob/main/.config/nvim/lua/setup/catppuccin.lua
    -- all = {
    --   NoiceCmdlinePopup = { bg = ucolors.lighten(colors.flamingo, 0.1, '#FFFFFF') },
    --   NoiceMini = { bg = colors.mantle },
    --   WinBar = { bg = lualine_bg },
    --   WinBarSigActParm = { fg = colors.blue, bg = lualine_bg },
    --   WinBarSignature = { fg = colors.flamingo, bg = lualine_bg },
    --   -- dims the text so that the hits are more visible
    --   LeapBackdrop = { fg = colors.flamingo },
    --   TelescopeBorder = { bg = telescope_results, fg = telescope_results },
    --   TelescopePromptBorder = { bg = telescope_prompt, fg = telescope_prompt },
    --   TelescopePromptCounter = { fg = telescope_text },
    --   TelescopePromptNormal = { fg = telescope_text, bg = telescope_prompt },
    --   TelescopePromptPrefix = { fg = telescope_prompt_title, bg = telescope_prompt },
    --   TelescopePromptTitle = { fg = telescope_prompt, bg = telescope_prompt_title },
    --   TelescopePreviewTitle = { fg = telescope_results, bg = telescope_preview_title },
    --   TelescopePreviewBorder = {
    --     bg = ucolors.darken(telescope_results, 0.95, '#000000'),
    --     fg = ucolors.darken(telescope_results, 0.95, '#000000'),
    --   },
    --   TelescopePreviewNormal = {
    --     bg = ucolors.darken(telescope_results, 0.95, '#000000'),
    --     fg = telescope_results,
    --   },
    --   TelescopeResultsTitle = { fg = telescope_results, bg = telescope_preview_title },
    --   TelescopeMatching = { fg = telescope_prompt_title },
    --   TelescopeNormal = { bg = telescope_results },
    --   TelescopeSelection = { bg = telescope_prompt },
    --   TelescopeSelectionCaret = { fg = telescope_text },
    --   TelescopeResultsNormal = { bg = telescope_results },
    --   TelescopeResultsBorder = { bg = telescope_results, fg = telescope_results },
    --   NavicIconsFile = { fg = colors.blue, bg = lualine_bg },
    -- }
    -- https://www.reddit.com/r/neovim/comments/xcsatv/comment/iq32go0/?utm_source=share&utm_medium=web2x&context=3
    all = {
      TelescopeMatching = { fg = colors.flamingo },
      TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },

      TelescopePromptPrefix = { bg = colors.surface0 },
      TelescopePromptNormal = { bg = colors.surface0 },
      TelescopeResultsNormal = { bg = colors.mantle },
      TelescopePreviewNormal = { bg = colors.mantle },
      TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
      TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
      TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
      TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
      TelescopeResultsTitle = { fg = colors.mantle },
      TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
    }
  }
})

lvim.colorscheme = "catppuccin"
