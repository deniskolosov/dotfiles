-- Copy this file to: ~/.config/nvim/lua/plugins/kata.lua
-- Or add this table to your existing plugins configuration

return {
  -- For local development/testing
  dir = "/Users/dkol/dev/kata-code",
  name = "kata-code",

  -- For production (after publishing to GitHub)
  -- "yourusername/kata-code.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",  -- Better UI
  },

  -- Optional: lazy load on commands
  cmd = {
    "KataTrack",
    "KataStart",
    "KataTest",
    "KataNext",
    "KataReset",
    "KataList",
  },

  -- Optional: lazy load on key mappings
  keys = {
    { "<leader>k", desc = "Kata menu" },
  },

  config = function()
    require("kata").setup({
      -- Optional customization
      -- default_language = "python",
      -- keymaps = {
      --   start = "<leader>ks",
      --   test = "<leader>kt",
      --   next = "<leader>kn",
      --   reset = "<leader>kr",
      --   list = "<leader>kl",
      -- },
    })
  end,
}
