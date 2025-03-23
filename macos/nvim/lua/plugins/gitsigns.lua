return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      -- target = "all" jump betweens staged/unstaged hunk. Default behaviour is to 
      -- cycle unstaged only
      map("n", "<leader>gj", function()
        gitsigns.nav_hunk("next", { target = "all" })
      end, { desc = "Jump to next git change" })

      map("n", "<leader>gk", function()
        gitsigns.nav_hunk("prev", { target = "all" })
      end, { desc = "Jump to previous git change" })

      -- Action
      -- normal mode
      map("n", "<leader>gl", gitsigns.blame_line, { desc = "Git blame line" })
      map(
        "n",
        "<leader>gL",
        "<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>",
        { desc = "Git blame line" }
      )
      map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Git preview hunk" })
      map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Git toggle stage hunk" })
      map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Git reset hunk" })

      -- visual mode
      map("v", "<leader>gs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Git stage hunk" })
      map("v", "<leader>gr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Git reset hunk" })
    end,
  },
  -- opts will be automatically passed into setup() call
  -- config = function ()
  --   local gitsigns = require("gitsigns")
  --   require("gitsigns").setup({
  --     on_attach = function (bufnr)
  --       vim.keymap.set("n", "<leader>gj", gitsigns.nav_hunk "next", { buffer = bufnr, desc = "Next hunk" })
  --       vim.keymap.set("n", "<leader>gl", gitsigns.blame_line, { buffer = bufnr, desc = "Next hunk" })
  --     end
  --   })
  -- end
}
