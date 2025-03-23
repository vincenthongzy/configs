local function augroup(name)
  return vim.api.nvim_create_augroup("hzy_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- Set folding based on LSP or treesitter
vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup("fold"),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldmethod = 'expr'
      vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'

      -- This is only supported in nvim-0.11
      -- vim.wo[win][0].foldmethod = 'expr'
      -- vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    else
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldmethod = 'expr'
      vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  end,
})
