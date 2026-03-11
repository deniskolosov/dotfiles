return {
  dir = "~/nv-plugins/study.nvim",
  cmd = { "StudyCards", "StudyStats", "StudyDaily", "StudyUpdate" },
  config = function()
    require("study").setup({
      card_paths = {
        vim.fn.expand("~/interview-prep/cards"),
      },
      scan_patterns = { "cards", "flashcard", "Flashcard" },
      vault_path = vim.fn.expand("~/interview-prep"),
    })
  end,
  keys = {
    { "<leader>sc", "<cmd>StudyCards<cr>", desc = "Review flashcards" },
    { "<leader>ss", "<cmd>StudyStats<cr>", desc = "Flashcard stats" },
    { "<leader>sd", "<cmd>StudyDaily<cr>", desc = "Open today's daily note" },
    { "<leader>su", "<cmd>StudyUpdate<cr>", desc = "Update problem state" },
  },
}
