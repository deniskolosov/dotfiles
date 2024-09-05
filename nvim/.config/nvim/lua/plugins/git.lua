return {
  {
    "lewis6991/gitsigns.nvim",
    config = function  ()
      require('gitsigns').setup()
      vim.keymap.set('n', '<leader>gt', '<cmd>lua require"gitsigns".toggle_signs()<CR>', { desc = "Toggle Git Signs" })
      vim.keymap.set('n', '<leader>gj', '<cmd>lua require"gitsigns".next_hunk()<CR>', { desc = "Next Git Hunk" })
      vim.keymap.set('n', '<leader>gk', '<cmd>lua require"gitsigns".prev_hunk()<CR>', { desc = "Prev Git Hunk" })
      vim.keymap.set('n', '<leader>gb', '<cmd>lua require"gitsigns".toggle_current_line_blame()<CR>', { desc = "Toggle line blame" })
      vim.keymap.set('n', '<leader>gp', '<cmd>lua require"gitsigns".preview_hunk_inline()<CR>', { desc = "Preview Git Hunk" })
      vim.keymap.set('n', '<leader>gr', '<cmd>lua require"gitsigns".reset_hunk()<CR>', { desc = "Reset Git Hunk" })
      vim.keymap.set('n', '<leader>gR', '<cmd>lua require"gitsigns".reset_buffer()<CR>', { desc = "Reset Git Buffer" })
      vim.keymap.set('n', '<leader>gS', '<cmd>lua require"gitsigns".stage_hunk()<CR>', { desc = "Stage Git Hunk" })
      vim.keymap.set('n', '<leader>gU', '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', { desc = "Undo Stage Git Hunk" })
    end
  },
  {
    "tpope/vim-fugitive"
  }
}
