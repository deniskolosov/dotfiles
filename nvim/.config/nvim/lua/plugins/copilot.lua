-- return {
--   "github/copilot.vim",
--   config = function ()
--     vim.api.nvim_set_keymap('n', '<leader>cp', ':Copilot enable<CR>', {noremap = true, silent = true})
--     vim.api.nvim_set_keymap('n', '<leader>cd', ':Copilot disable<CR>', {noremap = true, silent = true})
--
--     vim.g.copilot_filetypes = {
--         go = false,
--     }
--
--   end
-- }
--
return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = false,
					auto_refresh = false,
					keymap = {
						jump_prev = "C-p",
						jump_next = "C-n",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom", -- | top | left | right | horizontal | vertical
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = false,
					auto_trigger = false,
					hide_during_completion = true,
					debounce = 75,
					keymap = {
						accept = "<M-\\>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				filetypes = {
					yaml = false,
					markdown = true,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
				copilot_node_command = "node", -- Node.js version must be > 18.x
				server_opts_overrides = {},
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		event = { "InsertEnter", "LspAttach" },
		fix_pairs = true,
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}
