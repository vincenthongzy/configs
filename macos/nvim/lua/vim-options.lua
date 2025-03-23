-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- Keymaps
vim.g.mapleader = " "
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set('n', "<M-Up>", ":resize +2<CR>", {desc = "Resize with arrows"})
vim.keymap.set('n', "<M-Down>", ":resize -2<CR>", {desc = "Resize with arrows"})
vim.keymap.set('n', "<M-Left>", ":vertical resize -2<CR>", {desc = "Resize with arrows"})
vim.keymap.set('n', "<M-Rigt>", ":vertical resize +2<CR>", {desc = "Resize with arrows"})
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Built-in commenting available for neovim v0.10. Ref https://tinyurl.com/vd7tcahk
vim.keymap.set("n", "<leader>/", ":normal gcc<CR><DOWN>", { desc = "[/] Toggle comment line" })
-- <Esc> - exists visual mode.
-- :normal executes keystrokes in normal mode.
-- gv - restores selection.
-- gc - toggles comment
-- <CR> sends the command
vim.keymap.set("v", "<leader>/", "<Esc>:normal gvgc<CR>", { desc = "[/] Toggle comment block" })
-- Quickfix
vim.keymap.set("n", "<leader>]q", ":cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set("n", "<leader>]q", ":cprev<CR>", { desc = "Prev quickfix" })
vim.keymap.set("n", "<C-q>", ":call QuickFixToggle()<CR>", { desc = "Prev quickfix" })

-- General
vim.g.have_nerd_font = true
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.showmode = false
-- Decrease how long we wait between combo keys
vim.opt.timeoutlen = 400
vim.opt.inccommand = 'split'
-- Show more lines for above preview
vim.opt.cwh = 12
vim.opt.ignorecase = true

-- How splits should be open
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Clipboard to share between os and vim register
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Folding
-- Ref: https://gist.github.com/lestoni/8c74da455cce3d36eb68
-- Ref: https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/
-- Possibly look info nvim-ufo
-- Turns out newest version of neovim has inbuilt lsp folding
-- Ref: https://www.reddit.com/r/neovim/comments/1h34lr4/neovim_now_has_the_builtin_lsp_folding_support/
vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
vim.o.foldcolumn = '0'
vim.o.foldenable = true
vim.o.foldlevelstart = 99
vim.o.foldlevel = 99


