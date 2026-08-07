-- ============================================================================
-- LSP 语言服务器配置: neovim/nvim-lspconfig
-- ============================================================================
--
-- 功能说明:
--   • 使用 Neovim 原生 LSP 客户端提供代码诊断、跳转、重命名、代码操作等功能
--   • 使用 nvim-lspconfig 提供常用语言服务器配置
--   • 使用 mason.nvim 安装和管理 LSP 二进制
--   • 使用 mason-lspconfig.nvim 连接 Mason 和 nvim-lspconfig
--   • 接入 blink.cmp 的 capabilities，增强 LSP 补全能力
--
-- 配置效果:
--   ├─ 代码诊断: 实时显示错误、警告、提示
--   ├─ 代码导航: 跳转定义、声明、实现、引用
--   ├─ 信息查看: 悬停查看文档
--   ├─ 代码重构: 重命名、代码操作
--   ├─ 自动安装: Mason 自动安装指定 LSP
--   └─ 自动启用: 只启用 Mason 已安装的 LSP
--
-- 支持的 LSP 服务器:
--   • lua_ls: Lua / Neovim 配置
--   • bashls: Bash / Shell
--   • jsonls: JSON
--   • yamlls: YAML
--   • gopls: Go
--   • rust_analyzer: Rust
--   • clangd: C / C++
--   • jdtls: Java
--   • kotlin_language_server: Kotlin
--   • html / cssls / ts_ls: Web 前端
--   • pyright: Python
--
-- Lazy.nvim 说明:
--   • nvim-lspconfig 在打开文件前加载
--   • dependencies 保证 mason / mason-lspconfig / blink.cmp 可用
--   • config 中使用 vim.lsp.config / vim.lsp.enable 的 Neovim 0.11+ 写法
--

return {
	{
		"neovim/nvim-lspconfig",

		-- 打开文件前加载 LSP 配置
		event = {
			"BufReadPre",
			"BufNewFile",
		},

		dependencies = {
			-- Mason 主程序
			{
				"mason-org/mason.nvim",
				opts = {
					ui = {
						border = "rounded",
					},
				},
			},

			-- Mason 和 lspconfig 的桥接插件
			"mason-org/mason-lspconfig.nvim",

			-- 补全能力来源
			"saghen/blink.cmp",
		},

		config = function()
			-- ====================================================================
			-- LSP 补全能力
			-- ====================================================================
			--
			-- 说明:
			--   blink.cmp 会扩展 LSP capabilities。
			--   如果没有这一步，补全仍可能工作，但能力不完整。
			--
			-- 处理方式:
			--   • 先创建 Neovim 默认 capabilities
			--   • 再交给 blink.cmp 扩展

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local ok_blink, blink_cmp = pcall(require, "blink.cmp")
			if ok_blink then
				capabilities = blink_cmp.get_lsp_capabilities(capabilities)
			end

			-- ====================================================================
			-- 要使用的 LSP 服务器
			-- ====================================================================

			local servers = {
				-- 脚本 / 配置
				"lua_ls", -- Lua / Neovim 配置
				"bashls", -- Bash / Shell
				"jsonls", -- JSON
				"yamlls", -- YAML

				-- 常用后端语言
				"gopls", -- Go
				"rust_analyzer", -- Rust
				"clangd", -- C / C++
				"jdtls", -- Java
				"kotlin_language_server", -- Kotlin

				-- 前端 / Web
				"html", -- HTML
				"cssls", -- CSS
				"ts_ls", -- JavaScript / TypeScript

				-- Python
				"pyright", -- Python
			}

			-- ====================================================================
			-- Mason 初始化
			-- ====================================================================

			require("mason").setup({
				ui = {
					border = "rounded",
				},
			})

			-- ====================================================================
			-- 通用 LSP 配置
			-- ====================================================================
			--
			-- 说明:
			--   先为所有 server 注入 capabilities。
			--   特定 server 的额外配置在下面单独覆盖。

			for _, server_name in ipairs(servers) do
				vim.lsp.config(server_name, {
					capabilities = capabilities,
				})
			end

			-- ====================================================================
			-- Lua LSP 特定配置
			-- ====================================================================
			--
			-- 作用:
			--   • 识别 vim 全局变量，避免 undefined-global
			--   • 识别 Neovim runtime 文件
			--   • 关闭第三方库检查弹窗
			--   • 关闭 telemetry

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,

				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},

						diagnostics = {
							globals = {
								"vim",
							},
						},

						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},

						telemetry = {
							enable = false,
						},
					},
				},
			})

			-- ====================================================================
			-- Go LSP 特定配置
			-- ====================================================================

			vim.lsp.config("gopls", {
				capabilities = capabilities,

				settings = {
					gopls = {
						-- 启用静态分析
						staticcheck = true,

						-- 使用占位符补全函数参数
						usePlaceholders = true,

						-- 完成未导入包的补全
						completeUnimported = true,

						-- 语义 token
						semanticTokens = true,

						analyses = {
							unusedparams = true,
							unusedwrite = true,
							nilness = true,
							shadow = true,
						},
					},
				},
			})

			-- ====================================================================
			-- Rust LSP 特定配置
			-- ====================================================================

			vim.lsp.config("rust_analyzer", {
				capabilities = capabilities,

				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
						},

						check = {
							command = "clippy",
						},

						procMacro = {
							enable = true,
						},
					},
				},
			})

			-- ====================================================================
			-- Clangd 特定配置
			-- ====================================================================

			vim.lsp.config("clangd", {
				capabilities = capabilities,

				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
				},
			})

			vim.lsp.config("nixd", {
				capabilities = capabilities,

				cmd = {
					"nixd",
				},

				fileTypes = {
					"nix",
				},

				root_markers = {
					"flake.nix",
					".git",
				},

				settings = {
					nixd = {
						nixpkgs = {
							expr = [[
                      import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs {}
                    ]],
						},

						formatting = {
							command = {
								"nixfmt",
							},
						},

						options = {
							nixos = {
								expr = [[
                        (builtins.getFlake (builtins.toString ./.))
                          .nixosConfigurations
                          ."catserver"
                          .options
                      ]],
							},

							home_manager = {
								expr = [[
                        (builtins.getFlake (builtins.toString ./.))
                          .nixosConfigurations
                          ."catserver"
                          .options
                          .home-manager
                          .users
                          .type
                          .getSubOptions []
                      ]],
							},
						},
					},
				},
			})

			vim.lsp.enable("nixd")
			-- ====================================================================
			-- Mason-lspconfig 初始化
			-- ====================================================================
			--
			-- 说明:
			--   mason-lspconfig.nvim 在 Neovim 0.11+ 下可以自动调用 vim.lsp.enable()。
			--   这里关闭 automatic_enable，改为手动启用已安装 server，便于排错。

			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = servers,
				automatic_enable = false,
			})

			-- ====================================================================
			-- 启用已安装的 LSP 服务器
			-- ====================================================================
			--
			-- 说明:
			--   只启用 Mason 当前已经安装完成的 server。
			--   如果某个 server 还没安装，先执行 :Mason 安装，或等待 Mason 自动安装完成后重启。

			local enabled_servers = {}
			for _, server_name in ipairs(servers) do
				enabled_servers[server_name] = true
			end

			vim.schedule(function()
				for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
					if enabled_servers[server_name] then
						vim.lsp.enable(server_name)
					end
				end
			end)

			-- ====================================================================
			-- 诊断显示配置
			-- ====================================================================

			vim.diagnostic.config({
				-- 在代码行右侧显示诊断
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},

				-- 在 signcolumn 显示诊断标记
				signs = true,

				-- 给问题代码加下划线
				underline = true,

				-- 插入模式下不更新诊断，减少输入时干扰
				update_in_insert = false,

				-- 按严重程度排序
				severity_sort = true,

				-- 浮动窗口配置
				float = {
					border = "rounded",
					source = "always",
				},
			})

			-- ====================================================================
			-- 诊断图标配置
			-- ====================================================================

			local diagnostic_signs = {
				Error = " ",
				Warn = " ",
				Hint = "󰌵 ",
				Info = " ",
			}

			for type, icon in pairs(diagnostic_signs) do
				local hl = "DiagnosticSign" .. type

				vim.fn.sign_define(hl, {
					text = icon,
					texthl = hl,
					numhl = "",
				})
			end

			-- ====================================================================
			-- LSP 快捷键
			-- ====================================================================
			--
			-- 说明:
			--   使用 LspAttach 自动命令。
			--   只有当前 buffer 真正挂载 LSP 后，才设置这些快捷键。

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP keymaps",

				callback = function(event)
					local bufnr = event.buf

					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, {
							buffer = bufnr,
							silent = true,
							noremap = true,
							desc = desc,
						})
					end

					-- ============================================================
					-- 跳转 / 查找
					-- ============================================================

					map("n", "gd", vim.lsp.buf.definition, "跳转到定义")
					map("n", "gD", vim.lsp.buf.declaration, "跳转到声明")
					map("n", "gi", vim.lsp.buf.implementation, "跳转到实现")
					map("n", "gr", vim.lsp.buf.references, "查找引用")

					-- ============================================================
					-- 文档 / 重构
					-- ============================================================

					map("n", "K", vim.lsp.buf.hover, "查看文档")
					map("n", "<leader>ca", vim.lsp.buf.code_action, "代码操作")

					-- ============================================================
					-- 诊断
					-- ============================================================

					map("n", "<leader>cd", vim.diagnostic.open_float, "查看当前行诊断")
					map("n", "[d", vim.diagnostic.goto_prev, "上一个诊断")
					map("n", "]d", vim.diagnostic.goto_next, "下一个诊断")
				end,
			})
		end,
	},
}
