return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			-- Default file explorer to replace netrw
			default_file_explorer = true,
			-- Columns to display in oil buffer
			columns = {
				"icon",
				"permissions",
				"size",
				"mtime",
			},
			-- Buffer-local options for oil buffers
			buf_options = {
				buflisted = false,
				bufhidden = "hide",
			},
			-- Window-local options for oil buffers
			win_options = {
				wrap = false,
				signcolumn = "no",
				cursorcolumn = false,
				foldcolumn = "0",
				spell = false,
				list = false,
				conceallevel = 3,
				concealcursor = "nvic",
			},
			-- Show files and directories that start with "."
			show_hidden = false,
			-- Enable experimental git support for showing git status
			experimental_watch_for_changes = true,
			view_options = {
				-- Show files and directories that start with "."
				show_hidden = false,
				-- Files that match this pattern will not be shown
				is_hidden_file = function(name, bufnr)
					return vim.startswith(name, ".")
				end,
				-- Files that match this pattern will never be shown
				is_always_hidden = function(name, bufnr)
					return false
				end,
			},
			-- Configuration for the floating window (if used via keybinding)
			float = {
				padding = 2,
				max_width = 0,
				max_height = 0,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
			},
			-- Git integration
			git = {
				-- Enable git integration for showing status icons
				add = function(path)
					return true
				end,
				mv = function(src_path, dest_path)
					return true
				end,
				rm = function(path)
					return true
				end,
			},
			-- Keymaps in oil buffer
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-s>"] = "actions.select_vsplit",
				["<C-h>"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["<C-c>"] = "actions.close",
				["<C-l>"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},
		})

		-- Set keybinding to open oil
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
