return {
  "ray-x/go.nvim",
  dependencies = {  -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("go").setup()

    -- Auto format on save
    local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        require('go.format').goimports()
      end,
      group = format_sync_grp,
    })

    -- Setup keybindings using which-key
    local wk = require("which-key")

    wk.add({
      -- Go group
      { "<leader>g", group = "Go" },

      -- Flat (frequently used) shortcuts
      { "<leader>gt", "<cmd>GoTest<cr>", desc = "Run all tests", ft = "go" },
      { "<leader>gT", "<cmd>GoTestFunc<cr>", desc = "Run test for current function", ft = "go" },
      { "<leader>gc", "<cmd>GoCoverage<cr>", desc = "Test coverage", ft = "go" },
      { "<leader>ga", "<cmd>GoAlt<cr>", desc = "Toggle test/source file", ft = "go" },
      { "<leader>gf", "<cmd>GoFillStruct<cr>", desc = "Fill struct", ft = "go" },
      { "<leader>gr", "<cmd>GoRun<cr>", desc = "Run current package", ft = "go" },
      { "<leader>gb", "<cmd>GoBuild<cr>", desc = "Build package", ft = "go" },
      { "<leader>gv", "<cmd>GoVet<cr>", desc = "Vet package", ft = "go" },
      { "<leader>gl", "<cmd>GoLint<cr>", desc = "Lint package", ft = "go" },

      -- Struct tags group
      { "<leader>gs", group = "Struct Tags", ft = "go" },
      { "<leader>gsa", "<cmd>GoAddTag<cr>", desc = "Add struct tags", ft = "go" },
      { "<leader>gsr", "<cmd>GoRmTag<cr>", desc = "Remove struct tags", ft = "go" },
      { "<leader>gsm", "<cmd>GoModifyTag<cr>", desc = "Modify struct tags", ft = "go" },

      -- Code generation group
      { "<leader>ge", group = "Code Generation", ft = "go" },
      { "<leader>gei", "<cmd>GoImpl<cr>", desc = "Implement interface", ft = "go" },
      { "<leader>gee", "<cmd>GoIfErr<cr>", desc = "Add if err != nil", ft = "go" },
      { "<leader>gec", "<cmd>GoCmt<cr>", desc = "Generate comments", ft = "go" },
      { "<leader>geg", "<cmd>GoAddTest<cr>", desc = "Generate test for function", ft = "go" },
    })
  end,
  event = {"CmdlineEnter"},
  ft = {"go", 'gomod'},
  build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries

}
