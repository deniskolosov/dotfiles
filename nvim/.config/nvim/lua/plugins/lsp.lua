return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup()
			local pylsp = require("mason-registry").get_package("python-lsp-server")
			pylsp:on("install:success", function()
				local function mason_package_path(package)
					local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
					return path
				end

				local path = mason_package_path("python-lsp-server")
				local command = path .. "/venv/bin/pip"
				local args = {
					"install",
					"pylsp-rope",
					"python-lsp-black",
					"pyflakes",
					"python-lsp-ruff",
					"pyls-flake8",
					"sqlalchemy-stubs",
				}

				require("plenary.job")
					:new({
						command = command,
						args = args,
						cwd = path,
					})
					:start()
			end)
			ensure_installed = {
				"lua_ls",
				"pylsp",
				"markdown-oxide",
			}
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local wk = require("which-key")
			local builtin = require("telescope.builtin")
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local setup_lsp_keybindings = function()
				wk.add({
					{ "<leader>l", group = "LSP" },
					{
						"<leader>ld",
						vim.lsp.buf.definition,
						desc = "Go to Definition",
					},
					{
						"<leader>fg",
						"<cmd>lua require('telescope.builtin').live_grep({ cwd = '~/.local/share/nvim/gp/chats' })<cr>",
						desc = "Search GPT files",
					},
					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					{
						"<leader>ld",
						vim.lsp.buf.definition,
						desc = "Go to Definition",
					},
					{
						"<leader>lD",
						vim.lsp.buf.declaration,
						desc = "Go to Declaration",
					},
					{
						"<leader>lh",
						vim.lsp.buf.hover,
						desc = "Show Hover Information",
					},
					{
						"<leader>lH",
						vim.lsp.buf.signature_help,
						desc = "Show Signature Help",
					},
					{
						"<leader>lr",
						vim.lsp.buf.references,
						desc = "Find References",
					},
					{
						"<leader>la",
						vim.lsp.buf.code_action,
						desc = "List Code Actions",
					},
					{
						"<leader>lR",
						vim.lsp.buf.rename,
						desc = "Rename Symbol",
					},
					{
						"<leader>lf",
						vim.diagnostic.open_float,
						desc = "Show Line Diagnostics",
					},
					{
						"<leader>l=",
						vim.lsp.buf.format,
						desc = "Format buffer",
					},
					{
						"<leader>E",
						vim.diagnostic.open_float,
						desc = "Show Line Diagnostics",
					},
					{
						"<leader>ln",
						vim.diagnostic.goto_next,
						desc = "Go to Next Diagnostic",
					},
					{
						"<leader>lp",
						vim.diagnostic.goto_prev,
						desc = "Go to Previous Diagnostic",
					},

					-- Fuzzy find all the symbols in your current workspace.
					{
						"<leader>ls",
						builtin.lsp_document_symbols,
						desc = "Lsp Document Symbols",
					},
					--  Similar to document symbols, except searches over your entire project.
					{
						"<leader>lS",
						builtin.lsp_dynamic_workspace_symbols,
						desc = "Lsp Document Symbols",
					},
				}, { prefix = "<leader>" })
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			lspconfig.lua_ls.setup({
				on_attach = setup_lsp_keybindings,
				capabilities = capabilities,
			})

			lspconfig.markdown_oxide.setup({
				on_attach = setup_lsp_keybindings,
				capabilities = capabilities,
			})

			lspconfig.pylsp.setup({
				on_attach = setup_lsp_keybindings,
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							ruff = {
								-- formatter + Linter + isort
								enabled = false,
								extendSelect = { "I" },
							},
							-- formatter options
							black = { enabled = false },
							autopep8 = { enabled = false },
							yapf = { enabled = true },
							-- linter options
							pylint = { enabled = false, executable = "pylint" },
							pyflakes = { enabled = false },
							pycodestyle = {
								enabled = true,
								maxLineLength = 120,
							},
							-- type checker
							pylsp_mypy = { enabled = true },
							mypy = { enabled = true },
							-- auto-completion options
							jedi_completion = { fuzzy = true },
							-- import sorting
							pyls_isort = { enabled = false },
							rope_completion = {
								enabled = true,
							},
							rope_autoimport = {
								enabled = true,
							},
							-- ... You can configure other plugins here as needed
						},
					},
				},
			})
		end,
	},
}
