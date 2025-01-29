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
			-- local pylsp = require("mason-registry").get_package("python-lsp-server")
			-- pylsp:on("install:success", function()
			-- 	local function mason_package_path(package)
			-- 		local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
			-- 		return path
			-- 	end
			--
			-- 	local path = mason_package_path("python-lsp-server")
			-- 	local command = path .. "/venv/bin/pip"
			-- 	local args = {
			-- 		"install",
			-- 		"pylsp-rope",
			-- 		-- "python-lsp-black",
			-- 		-- "pyflakes",
			-- 		"python-lsp-ruff",
			-- 		-- "pyls-flake8",
			-- 		"sqlalchemy-stubs",
			-- 	}
			--
			-- 	require("plenary.job")
			-- 		:new({
			-- 			command = command,
			-- 			args = args,
			-- 			cwd = path,
			-- 		})
			-- 		:start()
			-- end)
			ensure_installed = {
				"lua_ls",
				"pylsp",
				"gopls",
        "pyright",
				"markdown-oxide",
			}
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- vim.lsp.set_log_level("debug")
			local lspconfig = require("lspconfig")
			local wk = require("which-key")
			local builtin = require("telescope.builtin")

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach_combined", { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client == nil then
						return
					end

					-- Disable hover in favor of Pyright for Ruff
					if client.name == "ruff" then
						client.server_capabilities.hoverProvider = false
						return
					end

					-- Create mapping function for LSP related bindings
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- LSP key mappings
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Document highlight
					if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

					-- Inlay hints toggle
					if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
				desc = "LSP: Combined auto commands",
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
			local util = require("lspconfig.util")

			lspconfig.lua_ls.setup({
				on_attach = setup_lsp_keybindings,
				capabilities = capabilities,
			})

			lspconfig.gopls.setup({
				on_attach = setup_lsp_keybindings,
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = util.root_pattern("go.mod", ".git"),
			})

			lspconfig.markdown_oxide.setup({
				on_attach = setup_lsp_keybindings,
				capabilities = capabilities,
			})


			-- lspconfig.pylsp.setup({
			-- 	on_attach = setup_lsp_keybindings,
			-- 	capabilities = capabilities,
			-- 	root_dir = util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt"),
			-- 	settings = {
			-- 		pylsp = {
			-- 			plugins = {
			-- 				ruff = {
			-- 					-- formatter + Linter + isort
			-- 					disabled = true,
			-- 				},
			-- 				-- formatter options
			-- 				black = { enabled = false },
			-- 				autopep8 = { enabled = false },
			-- 				yapf = { enabled = false },
			-- 				-- linter options
			-- 				pylint = { enabled = false, executable = "pylint" },
			-- 				pyflakes = { enabled = false },
			-- 				pycodestyle = {
			-- 					enabled = true,
			-- 					maxLineLength = 120,
			-- 				},
			-- 				-- type checker
			-- 				pylsp_mypy = { enabled = true },
			-- 				mypy = { enabled = false },
			-- 				-- auto-completion options
			-- 				jedi_completion = { fuzzy = true },
			-- 				-- import sorting
			-- 				pyls_isort = { enabled = false },
			-- 				rope_completion = {
			-- 					enabled = true,
			-- 				},
			-- 				rope_autoimport = {
			-- 					enabled = true,
			-- 				},
			-- 				-- ... You can configure other plugins here as needed
			-- 			},
			-- 		},
			-- 	},
			-- })

      lspconfig.pyright.setup({
        on_attach = function(client, bufnr)
          -- Example: you can define key mappings here for LSP commands.
          -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
          -- local opts = { noremap = true, silent = true }
          -- Key mappings
          -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          -- buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          -- buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

          -- Example command configurations can also be added here
        end,

        flags = {
          -- For performance improvement
          debounce_text_changes = 150,
        },

        -- Pyright-specific settings can be added here.
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "strict",  -- can be "off", "basic", or "strict"
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

			lspconfig.ruff.setup({
				init_options = {
					settings = {
						-- Ruff language server settings go here
						args = { "--max-line-length=120", "--select=E,W,F,N" }, -- Example: setting max line length and selecting specific error codes
						exclude = { "*.pyc", "__pycache__" }, -- Exclude specific patterns, like compiled Python files and caches
					},
				},
			})

			lspconfig.ts_ls.setup({
				on_attach = setup_lsp_keybindings,
				capabilities = capabilities,
			})

			lspconfig.html.setup({
				on_attach = setup_lsp_keybindings,
				capabilities = capabilities,
			})

		end,
	},
}
