return {
	"tpope/vim-dadbod",
	"kristijanhusak/vim-dadbod-completion",
	"kristijanhusak/vim-dadbod-ui",
	config = function()
		vim.api.nvim_set_keymap('n', '<leader>b', ':DBUIToggle<CR>', { noremap = true, silent = true })
	end,
}

