---@diagnostic disable: unused-function
-- Set options related to indentation and tabs
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.tabstop = 2        -- Number of spaces that a <Tab> in the file uses
vim.opt.softtabstop = 2    -- Number of spaces that a <Tab> counts for while performing editing operations

-- Set option to show line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- It's often good to configure related settings for a more coherent behavior.
-- For instance, the `shiftwidth` option should typically match `tabstop` when using spaces.
vim.opt.shiftwidth = 2     -- Number of spaces to use for each step of (auto)indent

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Function to open or create a markdown file with the current date
function open_todo_file()
    -- Get the current date in the format dd.mm.yy
    local date_str = os.date("%d.%m.%y")
    local filename = "~/dev/todos/" .. date_str .. ".md"
    -- Open the file in a new buffer
    vim.cmd("e " .. filename)
end

-- Function to toggle a markdown checkbox on the current line
function toggle_checkbox()
    -- Get the current line
    local line = vim.fn.getline(".")
    -- Pattern to identify and toggle the checkbox
    local unchecked_pattern = "%- %[ %]"
    local checked_pattern = "%- %[x%]"
    -- Check if the line contains an unchecked box and toggle it
    if string.match(line, unchecked_pattern) then
        line = string.gsub(line, "%- %[ %]", "- [x]")
    -- Check if the line contains a checked box and toggle it
    elseif string.match(line, checked_pattern) then
        line = string.gsub(line, "%- %[x%]", "- [ ]")
    end

    -- Set the current line to the modified content
    vim.fn.setline(".", line)
end

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set('n', '<leader>pt', ':lua open_todo_file()<CR>', { silent = true })
vim.keymap.set('n', '<leader>pl', ':lua toggle_checkbox()<CR>', {  silent = true })

-- remap escape to jk in insert mode
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })
--
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
