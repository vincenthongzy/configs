-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
lvim.plugins = {
  { "catppuccin/nvim",                                           name = "catppuccin" },
  { "git@github.com:nvim-telescope/telescope-ui-select.nvim.git" },
  { "sainnhe/gruvbox-material" },
  { "maxmx03/solarized.nvim" },
  { "jose-elias-alvarez/typescript.nvim" },
  { "nvim-treesitter/nvim-treesitter-textobjects" }
}
-- override lvim defaults
-- monorepo support
lvim.builtin.project.patterns = { ">Projects", ".git" }
lvim.format_on_save = true
lvim.builtin.which_key.setup.plugins.presets.z = true
vim.opt.foldmethod = "indent" -- default is "normal"
vim.opt.foldenable = false
vim.opt.showcmd = true
-- custom keymaps
lvim.keys.insert_mode["jk"] = "<ESC>"
-- https://salferrarello.com/vim-close-all-buffers-except-the-current-one/
vim.cmd("command! CloseOthers silent! execute '%bdelete|edit #| bd# | normal `\"'")
lvim.keys.normal_mode["<leader>bd"] = ":CloseOthers<cr>"
--treesitter enhancement
--https://github.com/LunarVim/LunarVim/issues/2730
--https://github.com/kylo252/lvim/blob/main/lua/user/treesitter.lua
lvim.builtin.treesitter.textobjects.select = {
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
  }
}
lvim.builtin.treesitter.textobjects.move = {
  enable = true,
  set_jumps = true, -- whether to set jumps in the jumplist
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
}
lvim.builtin.treesitter.textobjects.lsp_interop = {
  enable = true,
  border = "rounded",
  peek_definition_code = {
    ["gpof"] = "@function.outer",
    ["gpoc"] = "@class.outer",
  },
}



-- lsp
-- https://github.com/LunarVim/LunarVim/discussions/3847
-- typescript.nvim provides vscode like code actions as well
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "eslint"
end, lvim.lsp.automatic_configuration.skipped_servers)
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tsserver" })
local capabilities = require("lvim.lsp").common_capabilities()
local common_on_attach = require("lvim.lsp").common_on_attach
require("typescript").setup({
  -- doesn't seem to be working, neovim not on 0.10
  server = {
    -- on_attach = function(client, bufnr)
    --   common_on_attach(client, bufnr)
    --   vim.lsp.buf.inlay_hint(bufr, true)
    -- end,
    -- settings = {
    --   typescript = {
    --     inlayHints = {
    --       includeInlayEnumMemberValueHints = true,
    --       includeInlayFunctionLikeReturnTypeHints = true,
    --       includeInlayFunctionParameterTypeHints = true,
    --       includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
    --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    --       includeInlayPropertyDeclarationTypeHints = true,
    --       includeInlayVariableTypeHints = true,
    --     },
    --   },
    -- },
    capabilities = capabilities,
    root_dir = require("lspconfig").util.root_pattern(".git"),
  },
})
local null_ls = require("null-ls")
null_ls.register({
  require("typescript.extensions.null-ls.code-actions")
})
vim.diagnostic.config({
  virtual_text = false,
})


-- scuffed project wide diagnostic (work specific)
ProjectDiagnostics = function()
  local root_file = vim.fn.expand('%:p:h:h')
  vim.api.nvim_exec2(
  -- "compiler tsc | setlocal makeprg=npx\\ tsc\\ --build\\ **\\/\\(services\\\\\\|packages\\)\\/**\\/\\(tsconfig.build.json\\\\\\|tsconfig.json\\) | make",
    "compiler tsc | setlocal makeprg=npx\\ tsc\\ --build\\ **\\/\\(services\\\\\\|packages\\)\\/**\\/tsconfig.build.json | make",
    {})

  local tsc_diag = vim.fn.getqflist()

  vim.api.nvim_exec2(
    string.format("lcd %s | compiler eslint | make %s | silent! redraw", root_file, root_file), {}
  )


  vim.fn.setqflist(tsc_diag, 'a');

  vim.cmd.cwindow();
end

vim.cmd(
  "command! SanityCheck lua ProjectDiagnostics()")

-- Show line diagnostics automatically in hover window
OpenDiagFloat = function()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      return
    end
  end
  vim.diagnostic.open_float(nil, { focusable = false })
end
vim.o.updatetime = 550
vim.cmd [[autocmd CursorHold,CursorHoldI * lua OpenDiagFloat()]]

--autocompletion
lvim.builtin.cmp.sources = {
  { name = 'nvim_lsp' },
}
local cmp_mapping = require("cmp.config.mapping")
-- this allows me to see all objects of a property
lvim.builtin.cmp.mapping["<C-s>"] = cmp_mapping.complete()
-- lualine
local components = require("lvim.core.lualine.components")
components.progress.left_padding = 2
components.progress.separator = {
  right = '',
}
components.branch.separator = {
  right = '',
}
components.location.separator = {
  left = ''
}
lvim.builtin.lualine.sections = {
  lualine_a = {
    { 'mode', separator = { left = '' }, right_padding = 2 },
    { 'tabs', mode = 1, use_mode_colors = true, fmt = function(name, context) return context.tabnr end }
  },
  lualine_b = {
    components.branch
  },
  lualine_y = {
    components.location
  },
  lualine_z = {
    components.progress }
}

local solarized_palette = require('solarized.palette')
local colors = solarized_palette.get_colors()
local custom_solarized_without_bold = {
  normal = {
    a = { fg = colors.base03, bg = colors.blue },
    b = { fg = colors.base02, bg = colors.base1 },
    c = { fg = colors.base1, bg = colors.base02 },
    z = { fg = colors.base03, bg = colors.blue },
  },
  insert = {
    a = { fg = colors.base03, bg = colors.green },
  },
  visual = {
    a = { fg = colors.base03, bg = colors.magenta },
  },
  replace = {
    a = { fg = colors.base03, bg = colors.red },
  },
  command = {
    a = { fg = colors.base03, bg = colors.orange },
  },
}

lvim.builtin.lualine.options.theme = custom_solarized_without_bold
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

-- typescript
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { exe = "eslint_d", filetypes = { "typescript", "typescriptreact" } }
-- }

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "prettier",
    filetypes = { "typescript", "typescriptreact" },
  },
}
-- local code_actions = require "lvim.lsp.null-ls.code_actions"
-- code_actions.setup {
--   {
--     exe = "eslint_d",
--     filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
--   },
-- }

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

-- lvim.colorscheme = "catppuccin"
-- vim.o.background = 'dark'
-- vim.g.gruvbox_material_background = 'medium'
-- vim.g.gruvbox_material_enable_bold = 1
-- lvim.colorscheme = "gruvbox-material"
require('solarized').setup({
  transparent = true,
  -- theme = 'neo',
  enables = {
    editor = true
  },
  highlights = function(colors)
    return {
      TelescopeMatching = { fg = colors.base3, },
      TelescopeSelection = { fg = colors.base1, bg = colors.base01 },
      -- so we don't get janky highlights that seem to have inverted colours
      Visual = { link = 'CursorLine' },
      -- https://github.com/nvim-lualine/lualine.nvim/issues/867
      StatusLine = { link = 'Normal' },
    }
  end
})
lvim.colorscheme = 'solarized'
