return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = {
          "c",
          "clojure",
          "comment",
          "css",
          "csv",
          "diff",
          "dockerfile",
          "go",
          "heex",
          "html",
          "javascript",
          "json",
          "json5",
          "lua",
          "nginx",
          "python",
          "query",
          "sql",
          "ssh_config",
          "tmux",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
        },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
    end
 }
