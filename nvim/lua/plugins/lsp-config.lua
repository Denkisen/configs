return {
	"neovim/nvim-lspconfig",
	event = "LazyFile",
	dependencies = {
		"saghen/blink.cmp",
		"mason.nvim",
		{ "mason-org/mason-lspconfig.nvim", config = function() end },
	},
	opts = function()
		---@class PluginLspOpts
		local ret = {
			-- options for vim.diagnostic.config()
			---@type vim.diagnostic.Opts
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
						[vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
						[vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
						[vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
					},
				},
			},
			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = true,
				exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
			},
			-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the code lenses.
			codelens = {
				enabled = false,
			},
			-- add any global capabilities here
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- LSP Server Settings
			---@type lspconfig.options
			servers = {
				bashls = {},
				marksman = {},
				clangd = {
					keys = {
						{ "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
						{ "<leader>ct", "<cmd>ClangdTypeHierarchy<cr>", desc = "Type Hierarchy" },
						{ "<leader>as", "<cmd>ClangdAST<cr>", desc = "Show AST" },
					},
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern(
							"Makefile",
							"configure.ac",
							"configure.in",
							"config.h.in",
							"meson.build",
							"meson_options.txt",
							"build.ninja",
							".clangd",
							".clang-tidy",
							".clang-format",
							"compile_commands.json",
							"build/compile_commands.json",
							"compile_flags.txt",
							".git"
						)(fname) or require("lspconfig.util").root_pattern(
							"compile_commands.json",
							"compile_flags.txt"
						)(fname) or require("lspconfig.util").find_git_ancestor(fname)
					end,
					capabilities = {
						offsetEncoding = { "utf-16" },
					},
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
					},
					init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true,
					},
				},
				pyright = {},
				bacon_ls = {
					enabled = diagnostics == "bacon-ls",
				},
				rust_analyzer = { enabled = false },
				jsonls = {},
				cmake = {},

				lua_ls = {
					-- mason = false, -- set to false if you don't want this server to be installed with mason
					-- Use this to add any additional keymaps
					-- for specific lsp servers
					-- ---@type LazyKeysSpec[]
					-- keys = {},
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
							doc = {
								privateName = { "^_" },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
				},
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				clangd = function(_, opts)
					local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
					require("clangd_extensions").setup(
						vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts })
					)
					return false
				end,
			},
		}
		return ret
	end,
	---@param opts PluginLspOpts
	config = function(_, opts)
		-- setup autoformat
		-- LazyVim.format.register(LazyVim.lsp.formatter())

		-- setup keymaps
		LazyVim.lsp.on_attach(function(client, buff)
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = buff, desc = "LSP: " .. desc })
			end
			local tele = require("telescope.builtin")
			-- Rename the variable under your cursor.
			--  Most Language Servers support renaming across files, etc.
			map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			-- Execute a code action, usually your cursor needs to be on top of an error
			-- or a suggestion from your LSP for this to activate.
			map("<leader>ca", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
			vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { buffer = buff, desc = "Lsp: code_action" })
			-- Find references for the word under your cursor.
			map("<leader>fr", tele.lsp_references, "[G]oto [R]eferences")
			-- Jump to the implementation of the word under your cursor.
			--  Useful when your language has ways of declaring types without an actual implementation.
			map("<leader>fi", tele.lsp_implementations, "[G]oto [I]mplementation")
			-- Jump to the definition of the word under your cursor.
			--  This is where a variable was first declared, or where a function is defined, etc.
			--  To jump back, press <C-t>.
			map("<leader>gd", tele.lsp_definitions, "[G]oto [D]efinition")
			-- WARN: This is not Goto Definition, this is Goto Declaration.
			--  For example, in C this would take you to the header.
			map("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
			-- Fuzzy find all the symbols in your current document.
			--  Symbols are things like variables, functions, types, etc.
			map("<leader>fs", tele.lsp_document_symbols, "Open Document Symbols")
			-- Fuzzy find all the symbols in your current workspace.
			--  Similar to document symbols, except searches over your entire project.
			map("<leader>fS", tele.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
			-- Jump to the type of the word under your cursor.
			--  Useful when you're not sure what type a variable is and you want to see
			--  the definition of its *type*, not where it was *defined*.
			map("<leader>ft", tele.lsp_type_definitions, "[G]oto [T]ype Definition")
			map("K", vim.lsp.buf.hover, "hover")
			map("<leader>E", vim.diagnostic.open_float, "diagnostic")
			map("<leader>k", vim.lsp.buf.signature_help, "sig help")
			map("<leader>rn", vim.lsp.buf.rename, "rename")
			map("<leader>wf", vim.lsp.buf.format, "format")

			require("lazyvim.plugins.lsp.keymaps").on_attach(client, buff)
		end)

		LazyVim.lsp.setup()
		LazyVim.lsp.on_dynamic_capability(require("lazyvim.plugins.lsp.keymaps").on_attach)

		-- diagnostics signs
		if vim.fn.has("nvim-0.10.0") == 0 then
			if type(opts.diagnostics.signs) ~= "boolean" then
				for severity, icon in pairs(opts.diagnostics.signs.text) do
					local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
					name = "DiagnosticSign" .. name
					vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
				end
			end
		end

		if vim.fn.has("nvim-0.10") == 1 then
			-- inlay hints
			if opts.inlay_hints.enabled then
				LazyVim.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
					if
						vim.api.nvim_buf_is_valid(buffer)
						and vim.bo[buffer].buftype == ""
						and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
					end
				end)
			end

			-- code lens
			if opts.codelens.enabled and vim.lsp.codelens then
				LazyVim.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
					vim.lsp.codelens.refresh()
					vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
						buffer = buffer,
						callback = vim.lsp.codelens.refresh,
					})
				end)
			end
		end

		if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
			opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
				or function(diagnostic)
					local icons = LazyVim.config.icons.diagnostics
					for d, icon in pairs(icons) do
						if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
							return icon
						end
					end
				end
		end

		vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

		local servers = opts.servers
		local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		local has_blink, blink = pcall(require, "blink.cmp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			has_cmp and cmp_nvim_lsp.default_capabilities() or {},
			has_blink and blink.get_lsp_capabilities() or {},
			opts.capabilities or {}
		)

		local function setup(server)
			local server_opts = vim.tbl_deep_extend("force", {
				capabilities = vim.deepcopy(capabilities),
			}, servers[server] or {})
			if server_opts.enabled == false then
				return
			end

			if opts.setup[server] then
				if opts.setup[server](server, server_opts) then
					return
				end
			elseif opts.setup["*"] then
				if opts.setup["*"](server, server_opts) then
					return
				end
			end
			require("lspconfig")[server].setup(server_opts)
		end

		-- get all the servers that are available through mason-lspconfig
		local have_mason, mlsp = pcall(require, "mason-lspconfig")
		local all_mslp_servers = {}
		if have_mason then
			all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
		end

		local ensure_installed = {} ---@type string[]
		for server, server_opts in pairs(servers) do
			if server_opts then
				server_opts = server_opts == true and {} or server_opts
				if server_opts.enabled ~= false then
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end
		end

		if have_mason then
			mlsp.setup({
				ensure_installed = vim.tbl_deep_extend(
					"force",
					ensure_installed,
					LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}
				),
				handlers = { setup },
			})
		end

		if LazyVim.lsp.is_enabled("denols") and LazyVim.lsp.is_enabled("vtsls") then
			local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
			LazyVim.lsp.disable("vtsls", is_deno)
			LazyVim.lsp.disable("denols", function(root_dir, config)
				if not is_deno(root_dir) then
					config.settings.deno.enable = false
				end
				return false
			end)
		end
	end,
}
