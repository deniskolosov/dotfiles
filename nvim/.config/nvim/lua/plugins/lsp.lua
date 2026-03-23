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
				"ty",
				"markdown-oxide",
			}
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- vim.lsp.set_log_level("debug")
			local wk = require("which-key")
			local builtin = require("telescope.builtin")

			-- Fix position_encoding warning by wrapping make_position_params
			local original_make_position_params = vim.lsp.util.make_position_params
			vim.lsp.util.make_position_params = function(window, offset_encoding)
				return original_make_position_params(window, offset_encoding or "utf-16")
			end

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
						function() vim.lsp.buf.definition() end,
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
						"<leader>F",
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
					{
						"<leader>lq",
						vim.diagnostic.setqflist,
						desc = "Send Diagnostics to Quickfix",
					},
					{
						"<leader>ll",
						vim.diagnostic.setloclist,
						desc = "Send Buffer Diagnostics to Loclist",
					},
					{
						"<leader>li",
						builtin.lsp_implementations,
						desc = "Go to Implementation",
					},
					{
						"<leader>lt",
						builtin.lsp_type_definitions,
						desc = "Go to Type Definition",
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
			capabilities.positionEncodings = { "utf-16", "utf-8" }

			-- Helper function to check if a command exists
			local function cmd_exists(cmd)
				return vim.fn.executable(cmd) == 1
			end

			-- Lua Language Server
			if cmd_exists("lua-language-server") then
				vim.lsp.config("lua_ls", {
					cmd = { "lua-language-server" },
					filetypes = { "lua" },
					root_dir = vim.fs.root(0, { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" }),
					capabilities = capabilities,
					on_attach = setup_lsp_keybindings,
				})
				vim.lsp.enable("lua_ls")
			end

			-- Go Language Server
			if cmd_exists("gopls") then
				vim.lsp.config("gopls", {
					cmd = { "gopls" },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					root_dir = vim.fs.root(0, { "go.mod", ".git" }),
					capabilities = capabilities,
					on_attach = setup_lsp_keybindings,
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							analyses = {
								unusedparams = true,
								shadow = true,
							},
							staticcheck = true,
						},
					},
				})
				vim.lsp.enable("gopls")
			end

			-- Markdown Oxide
			if cmd_exists("markdown-oxide") then
				vim.lsp.config("markdown_oxide", {
					cmd = { "markdown-oxide" },
					filetypes = { "markdown" },
					root_dir = vim.fs.root(0, { ".git", ".marksman.toml" }),
					capabilities = capabilities,
					on_attach = setup_lsp_keybindings,
				})
				vim.lsp.enable("markdown_oxide")
			end

			-- -- Pyright
			-- if cmd_exists("pyright-langserver") then
			-- 	vim.lsp.config("pyright", {
			-- 		cmd = { "pyright-langserver", "--stdio" },
			-- 		filetypes = { "python" },
			-- 		root_dir = vim.fs.root(0, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" }),
			-- 		capabilities = capabilities,
			-- 		on_attach = setup_lsp_keybindings,
			-- 		settings = {
			-- 			python = {
			-- 				analysis = {
			-- 					typeCheckingMode = "basic",
			-- 					autoSearchPaths = true,
			-- 					useLibraryCodeForTypes = true,
			-- 				},
			-- 			},
			-- 		},
			-- 	})
			-- 	vim.lsp.enable("pyright")
			-- end
      vim.lsp.config('ty', {
        settings = {
          ty = {
            -- ty language server settings go here
          }
        }
      })

      -- Required: Enable the language server
      vim.lsp.enable('ty')

			-- Ruff
			if cmd_exists("ruff") then
				vim.lsp.config("ruff", {
					cmd = { "ruff", "server" },
					filetypes = { "python" },
					root_dir = vim.fs.root(0, { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" }),
					init_options = {
						settings = {
							args = { "--max-line-length=120", "--select=E,W,F,N" },
							exclude = { "*.pyc", "__pycache__" },
						},
					},
				})
				vim.lsp.enable("ruff")
			end

			-- TypeScript Language Server
			if cmd_exists("typescript-language-server") then
				vim.lsp.config("ts_ls", {
					cmd = { "typescript-language-server", "--stdio" },
					filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
					root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", "jsconfig.json", ".git" }),
					capabilities = capabilities,
					on_attach = setup_lsp_keybindings,
				})
				vim.lsp.enable("ts_ls")
			end

			-- HTML Language Server
			if cmd_exists("vscode-html-language-server") then
				vim.lsp.config("html", {
					cmd = { "vscode-html-language-server", "--stdio" },
					filetypes = { "html" },
					root_dir = vim.fs.root(0, { "package.json", ".git" }),
					capabilities = capabilities,
					on_attach = setup_lsp_keybindings,
				})
				vim.lsp.enable("html")
			end

			-- Vue Language Server
			if cmd_exists("vue-language-server") then
				vim.lsp.config("vue_ls", {
					cmd = { "vue-language-server", "--stdio" },
					filetypes = { "vue" },
					root_dir = vim.fs.root(0, { "package.json", ".git" }),
					capabilities = capabilities,
					on_attach = setup_lsp_keybindings,
				})
				vim.lsp.enable("vue_ls")
			end

			-- CSS Language Server
			if cmd_exists("vscode-css-language-server") then
				vim.lsp.config("cssls", {
					cmd = { "vscode-css-language-server", "--stdio" },
					filetypes = { "css" },
					root_dir = vim.fs.root(0, { "package.json", ".git" }),
					capabilities = capabilities,
					on_attach = setup_lsp_keybindings,
				})
				vim.lsp.enable("cssls")
			end

		end,
	},
}
