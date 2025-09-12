return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    notify = false,
    preset = "modern",
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
