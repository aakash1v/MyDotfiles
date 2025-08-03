-- LSP Configuration with Mason, Formatters, and Linters (with Explanations)
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim", -- LSP installer
		"williamboman/mason-lspconfig.nvim", -- Bridges mason with lspconfig
		"WhoIsSethDaniel/mason-tool-installer.nvim", -- Installs extra tools (like formatters/linters)

		-- Optional: LSP progress UI
		{
			"j-hui/fidget.nvim",
			tag = "v1.4.0",
			opts = {
				progress = {
					display = {
						done_icon = "✓",
					},
				},
				notification = {
					window = {
						winblend = 0,
					},
				},
			},
		},
	},

	config = function()
		-- Define LSP keymaps per buffer when the LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- LSP Keymaps
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
				map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
				map("<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, "[W]orkspace [L]ist Folders")

				-- Highlight word under cursor
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})

		-- LSP Capabilities (for completion)
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Define servers and their specific settings
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
						},
						completion = { callSnippet = "Replace" },
						telemetry = { enable = false },
						diagnostics = { disable = { "missing-fields" } },
					},
				},
			},

			["typescript-language-server"] = { -- TypeScript/JavaScript support
				settings = {
					typescript = { format = { enable = false } }, -- disable tsserver formatting
					javascript = { format = { enable = false } },
				},
			},

			pylsp = { -- Python LSP
				settings = {
					pylsp = {
						plugins = {
							pyflakes = { enabled = false },
							pycodestyle = { enabled = false },
							autopep8 = { enabled = false },
							yapf = { enabled = false },
							mccabe = { enabled = false },
							pylsp_mypy = { enabled = false },
							pylsp_black = { enabled = false },
							pylsp_isort = { enabled = false },
						},
					},
				},
			},

			-- These are language servers without custom configs
			jsonls = {},
			sqlls = {},
			terraformls = {},
			yamlls = {},
			bashls = {},
			dockerls = {},
			docker_compose_language_service = {},
			html = {}, -- HTML LSP
			cssls = {}, -- CSS LSP

			emmet_ls = {}, -- Optional: Emmet support for HTML/CSS abbreviations
		}

		-- Setup Mason (for installing LSPs/tools)
		require("mason").setup()

		-- Tools to auto-install (formatters, linters, etc.)
		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, {
			"stylua", -- Lua formatter
			"typescript-language-server",
			"prettier", -- JS/TS formatter
			"eslint", -- JS/TS linter
			"tailwindcss-language-server", -- Tailwind support (optional)
			"ruff-lsp", -- Python formatter/linter via Ruff (correct version)
			"html-lsp",
			"css-lsp",
			"emmet-ls",
			"pyright" -- python LSP
		})

		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
			integrations = { ["mason-lspconfig"] = true },
		})

		-- Final LSP setup loop
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
