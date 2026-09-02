-- ============================================================================
-- 代码补全引擎: saghen/blink.cmp
-- ============================================================================
--
-- 功能说明:
--   • 使用 blink.cmp 提供高性能代码补全
--   • 支持 LSP、路径、代码片段、Buffer 内容等补全来源
--   • 支持函数签名提示和补全文档弹窗
--   • 替代传统 nvim-cmp，配置更集中，性能更好
--
-- 配置效果:
--   ├─ LSP 补全: 从语言服务器获取智能补全候选项
--   ├─ 路径补全: 输入路径时自动补全文件和目录
--   ├─ 片段补全: 集成 friendly-snippets 常用代码片段
--   ├─ Buffer 补全: 从当前 buffer 文本中提取候选项
--   ├─ 文档提示: 自动显示补全文档
--   └─ 签名提示: 输入函数参数时显示 signature help
--
-- Lazy.nvim 说明:
--   • version = "1.*" 锁定 blink.cmp v1 主版本
--   • lazy = false 表示启动时加载，保证 LSP 初始化时能读取 capabilities
--   • dependencies 引入 friendly-snippets
--   • opts 会自动传给 require("blink.cmp").setup(...)
--

return {
	{
		"saghen/blink.cmp",

		-- 锁定 v1 主版本，避免 v2 破坏性更新导致配置失效
		version = "1.*",

		-- 不懒加载
		-- 原因:
		--   • LSP 初始化时需要读取 blink.cmp 的 capabilities
		--   • 如果使用 event = "InsertEnter"，LSP 可能先于 blink.cmp 加载
		--   • 这会导致 LSP capabilities 回退到默认值
		lazy = false,

		-- 常用 snippets 集合
		dependencies = {
			"rafamadriz/friendly-snippets",
		},

		-- 允许其他插件模块继续扩展 sources.default
		opts_extend = {
			"sources.default",
		},

		opts = {
			-- ====================================================================
			-- 快捷键配置
			-- ====================================================================

			keymap = {
				-- enter:
				--   Enter 确认补全
				--   Ctrl-y 也可以确认补全
				preset = "enter",

				-- 上下选择候选项
				["<Up>"] = {
					"select_prev",
					"fallback",
				},

				["<Down>"] = {
					"select_next",
					"fallback",
				},

				-- Tab / Shift-Tab 切换补全项
				["<Tab>"] = {
					"select_next",
					"fallback",
				},

				["<S-Tab>"] = {
					"select_prev",
					"fallback",
				},

				-- 文档滚动
				["<C-b>"] = {
					"scroll_documentation_up",
					"fallback",
				},

				["<C-f>"] = {
					"scroll_documentation_down",
					"fallback",
				},

				-- 函数签名提示
				["<C-k>"] = {
					"show_signature",
					"hide_signature",
					"fallback",
				},
			},

			-- ====================================================================
			-- 外观配置
			-- ====================================================================

			appearance = {
				-- mono:
				--   适合 Nerd Font Mono
				--   图标对齐更稳定
				nerd_font_variant = "mono",
			},

			-- ====================================================================
			-- 补全来源
			-- ====================================================================
			--
			-- lsp:
			--   语言服务器补全
			--
			-- path:
			--   文件路径补全
			--
			-- snippets:
			--   代码片段补全
			--
			-- buffer:
			--   当前 buffer 文本补全

			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
				},
			},

			-- ====================================================================
			-- 模糊匹配
			-- ====================================================================

			fuzzy = {
				-- 优先使用 Rust fuzzy matcher
				-- 如果不可用则给出警告
				implementation = "prefer_rust_with_warning",
			},

			-- ====================================================================
			-- 补全窗口配置
			-- ====================================================================

			completion = {
				keyword = {
					-- prefix:
					--   只补全当前前缀范围
					range = "prefix",
				},

				menu = {
					draw = {
						-- 对 LSP 补全项启用 treesitter 辅助渲染
						treesitter = {
							"lsp",
						},
					},
				},

				trigger = {
					-- 输入触发字符时自动显示补全
					-- 例如 . / : / -> 等
					show_on_trigger_character = true,
				},

				documentation = {
					-- 自动显示补全文档
					auto_show = true,

					-- 延迟 200ms 显示，避免窗口闪烁
					auto_show_delay_ms = 200,
				},

				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
			},

			-- ====================================================================
			-- 函数签名提示
			-- ====================================================================

			signature = {
				enabled = true,
			},
		},
	},
}
