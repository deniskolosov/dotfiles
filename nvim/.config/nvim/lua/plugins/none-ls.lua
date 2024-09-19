return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require('null-ls')
    null_ls.setup({
      filetypes = {"javascript", "typescript", "html", "css", "go"},
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports_reviser,
      },
    })
  end
}
