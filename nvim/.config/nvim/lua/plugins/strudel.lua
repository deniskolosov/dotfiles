return {
  "gruvw/strudel.nvim",
  lazy = false,
  build = "npm install",
  config = function()
    require("strudel").setup({
      browser_exec_path =
      "/Users/dkol/.cache/puppeteer/chrome/mac_arm-140.0.7339.82/chrome-mac-arm64/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing",
    })
    local strudel = require("strudel")

    vim.keymap.set("n", "<leader>sl", strudel.launch, { desc = "Launch Strudel" })
    vim.keymap.set("n", "<leader>sq", strudel.quit, { desc = "Quit Strudel" })
    vim.keymap.set("n", "<leader>st", strudel.toggle, { desc = "Strudel Toggle Play/Stop" })
    vim.keymap.set("n", "<leader>su", strudel.update, { desc = "Strudel Update" })
    vim.keymap.set("n", "<leader>ss", strudel.stop, { desc = "Strudel Stop Playback" })
    vim.keymap.set("n", "<leader>sb", strudel.set_buffer, { desc = "Strudel set current buffer" })
    vim.keymap.set("n", "<leader>sx", strudel.execute, { desc = "Strudel set current buffer and update" })
  end,
}
