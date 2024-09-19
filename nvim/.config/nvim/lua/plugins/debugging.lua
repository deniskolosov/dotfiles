return {
  {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
  },
  config = function ()

    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    require("dap-python").setup("~/dev/apibank/rassrochki-api/.venv/bin/python")



    vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require("dap").continue()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>dr', ':lua require("dap").step_over()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>di', ':lua require("dap").step_into()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>do', ':lua require("dap").step_out()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>dt', ':lua require("dap").toggle_breakpoint()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>du', ':lua require("dap").up()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>ds', ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>d.', ':lua require("dap").repl.open()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>dl', ':lua require("dap").run_last()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>dm', ':lua require("dap-python").test_method()<CR>', {noremap = true, silent = true})




--     nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
-- nnoremap <silent> <leader>df :lua require('dap-python').test_class()<CR>
-- vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>
  end
  },
  {
    "leoluz/nvim-dap-go",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function ()
      local ft = "go"
      require("dap-go").setup()
    end
}
}
