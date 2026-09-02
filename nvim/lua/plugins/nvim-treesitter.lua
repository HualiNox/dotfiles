-- ============================================================================
-- 语法解析增强: nvim-treesitter/nvim-treesitter
-- ============================================================================
--
-- 功能说明:
--   • 使用 Tree-sitter 提供更准确的语法高亮
--   • 使用 nvim-treesitter main 分支的新接口安装和管理 parser
--   • 使用 Neovim 内置 vim.treesitter.start() 启用 Tree-sitter 高亮
--   • C / C++ 只使用 Tree-sitter 高亮，缩进交给 Neovim 自带 cindent
--   • Markdown 禁用 Tree-sitter 接管，避免 markdown / markdown_inline 报错
--   • jsonc 文件复用 json parser，避免 unsupported language: jsonc
--   • 日常启动异步安装缺失 parser，避免阻塞启动
--   • 提供同步安装命令，用于首次初始化或修复 parser / query 不匹配
--
-- 配置效果:
--   ├─ 高亮: 由 Neovim 内置 Tree-sitter 高亮接口接管
--   ├─ Parser 管理: 使用 require("nvim-treesitter").install(...) 安装 parser
--   ├─ 异步安装: 日常启动后后台安装缺失 parser，不阻塞 UI
--   ├─ 同步安装: 手动执行 :UserTSInstallSync 时等待 parser 安装完成
--   ├─ C/C++ 缩进: 使用 cindent，避免 Tree-sitter 缩进异常
--   ├─ Markdown: 回退到普通 markdown 语法处理，避免 md 文件报错
--   ├─ jsonc: 复用 json parser，不再单独安装 jsonc parser
--   └─ 兼容: 适配 nvim-treesitter main 分支配置方式
--
-- 注意:
--   • 当前配置使用 branch = "main"
--   • main 分支是 nvim-treesitter 的不兼容重写版本
--   • main 分支不再使用 require("nvim-treesitter.configs").setup(...)
--   • main 分支不再使用 ensure_installed / highlight.enable / indent.enable
--   • main 分支不支持 lazy-loading，因此这里必须使用 lazy = false
--   • main 分支官方要求 Neovim 0.12.0 或更新版本
--   • main 分支需要 tree-sitter-cli、tar、curl、C 编译器在 PATH 中
--
-- Lazy.nvim 说明:
--   • lazy = false 表示启动时加载，符合 main 分支要求
--   • branch = "main" 表示使用新版 nvim-treesitter 接口
--   • build = ":TSUpdate" 只在安装 / 更新 / Lazy sync 后更新已安装 parser
--   • config 用于 setup、安装 parser，并配置各文件类型的启用策略
--
-- 常用命令:
--   • :UserTSInstallSync  同步安装 parser，适合首次初始化或修复环境
--   • :TSUpdate           更新已安装 parser
--   • :checkhealth nvim-treesitter
--
-- 迁移说明:
--   • 旧版 incremental_selection 模块在 main 分支中不再按旧方式配置
--   • 如果需要 textobjects / 结构选择，建议后续单独配置 nvim-treesitter-textobjects
--

return {
	{
		"nvim-treesitter/nvim-treesitter",

			-- 使用新版 main 分支
			branch = "main",
			dependencies = {
				"neovim-treesitter/treesitter-parser-registry",
			},

			-- main 分支不支持 lazy-loading
		lazy = false,

		-- Lazy.nvim 的 build hook:
		--   • 只在插件安装 / 更新 / Lazy sync 后执行
		--   • 用于更新已经安装的 parser
		--   • 不等于每次启动都同步安装 parser
		build = ":TSUpdate",

		config = function()
			-- ====================================================================
			-- 基础配置
			-- ====================================================================

			local ts = require("nvim-treesitter")

			-- Parser / query 安装目录
			-- 放到 stdpath("data") .. "/site" 是 main 分支推荐方式
			local install_dir = vim.fn.stdpath("data") .. "/site"

			-- 让 nvim-treesitter 安装的 parser / query 优先于 Neovim 内置 runtime
			-- 用于减少 parser 和 query 版本不匹配问题
			vim.opt.runtimepath:prepend(install_dir)

			ts.setup({
				install_dir = install_dir,
			})

			-- jsonc 没有作为独立 parser 安装
			-- 这里让 jsonc 文件复用 json parser
			vim.treesitter.language.register("json", "jsonc")

			-- ====================================================================
			-- Parser 安装列表
			-- ====================================================================
			--
			-- 注意:
			--   • main 分支不再使用 ensure_installed
			--   • 这里使用 ts.install(parsers)
			--   • 不要加入 "jsonc"，否则会出现 unsupported language: jsonc
			--   • markdown / markdown_inline 可以安装，但下面不会自动启用
			--

			local parsers = {
				-- Neovim / Lua
				"lua",
				"luadoc",
				"vim",
				"vimdoc",

				-- Shell / 配置
				"bash",
				"json",
				"yaml",
				"toml",

				-- Go
				"go",
				"gomod",
				"gosum",
				"gowork",

				-- Rust
				"rust",

				-- C / C++
				"c",
				"cpp",

				-- JVM
				"java",
				"kotlin",

				-- Python
				"python",

				-- Web
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",

				-- 文档
				-- 当前仅安装，不自动启用，避免 md 文件报错
				"markdown",
				"markdown_inline",

				-- 其他常用
				"dockerfile",
				"gitignore",
				"regex",
				"query",
			}

			-- ====================================================================
			-- Parser 安装策略
			-- ====================================================================
			--
			-- 问题说明:
			--   • ts.install(...) 默认异步安装
			--   • 如果每次启动都 install_result:wait(...)，nvim 启动会被阻塞
			--   • 日常使用应异步安装，首次初始化或修复时再手动同步
			--
			-- 处理方式:
			--   • install_parsers_async(): 启动后异步安装缺失 parser
			--   • install_parsers_sync(): 手动命令同步等待安装完成
			--   • :UserTSInstallSync 用于首次初始化或修复 parser / query 不匹配
			--

			local function install_parsers_async()
				local ok, result = pcall(ts.install, parsers)

				if not ok then
					vim.notify("nvim-treesitter async install failed: " .. tostring(result), vim.log.levels.ERROR)
				end
			end

			local function install_parsers_sync()
				local ok, result = pcall(ts.install, parsers)

				if not ok then
					vim.notify("nvim-treesitter sync install failed: " .. tostring(result), vim.log.levels.ERROR)
					return
				end

				if result and type(result.wait) == "function" then
					-- 最多等待 5 分钟
					result:wait(300000)
				end

				vim.notify("nvim-treesitter parsers installed / updated", vim.log.levels.INFO)
			end

			vim.api.nvim_create_user_command("UserTSInstallSync", function()
				install_parsers_sync()
			end, {
				desc = "Install nvim-treesitter parsers synchronously",
			})

			-- 日常启动后延迟异步安装，避免和打开首个文件抢资源
			vim.defer_fn(function()
				install_parsers_async()
			end, 2000)

			-- ====================================================================
			-- Tree-sitter 高亮启用列表
			-- ====================================================================
			--
			-- 注意:
			--   • main 分支不再通过 highlight.enable = true 启用高亮
			--   • 需要在 FileType 事件中调用 vim.treesitter.start()
			--   • lua 暂时不放在这里，因为 Neovim 0.12 的 ftplugin/lua.lua 会自动启动
			--   • markdown 不放在这里，避免 markdown / markdown_inline 报错
			--

			local treesitter_filetypes = {
				-- Vim
				"vim",
				"vimdoc",
				"help",

				-- Shell / 配置
				"bash",
				"sh",
				"json",
				"jsonc",
				"yaml",
				"toml",

				-- Go
				"go",
				"gomod",
				"gosum",
				"gowork",

				-- Rust
				"rust",

				-- C / C++
				"c",
				"cpp",

				-- JVM
				"java",
				"kotlin",

				-- Python
				"python",

				-- Web
				"html",
				"css",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"tsx",

				-- 其他
				"dockerfile",
				"gitignore",
				"regex",
				"query",
			}

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitterStart", {
					clear = true,
				}),
				pattern = treesitter_filetypes,
				callback = function(args)
					-- 使用 pcall 避免单个 parser / query 异常导致整个启动失败
					pcall(vim.treesitter.start, args.buf)
				end,
			})

			-- ====================================================================
			-- C / C++ 缩进修复
			-- ====================================================================
			--
			-- 问题说明:
			--   • Tree-sitter indent 对 C / C++ 的复杂结构支持不稳定
			--   • lambda、模板、namespace、宏、多行初始化等场景容易缩进异常
			--
			-- 处理方式:
			--   • 不使用 nvim-treesitter indentexpr()
			--   • 清空 indentexpr
			--   • 启用 Neovim/Vim 自带 cindent
			--

			local function setup_c_family_indent()
				vim.bo.indentexpr = ""
				vim.bo.cindent = true
				vim.bo.autoindent = true
				vim.bo.smartindent = false

				-- 常用 C / C++ 缩进宽度
				vim.bo.tabstop = 4
				vim.bo.shiftwidth = 4
				vim.bo.softtabstop = 4
				vim.bo.expandtab = true

				-- C/C++ 注释格式
				vim.bo.commentstring = "// %s"
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserCFamilyIndent", {
					clear = true,
				}),
				pattern = {
					"c",
					"cpp",
				},
				callback = setup_c_family_indent,
			})

			-- 如果当前 buffer 已经是 C / C++，立即应用一次
			if vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
				setup_c_family_indent()
			end

			-- ====================================================================
			-- Markdown 修复
			-- ====================================================================
			--
			-- 问题说明:
			--   • markdown / markdown_inline 在部分版本组合下容易报错
			--   • conceal 会隐藏部分 markdown 符号，影响编辑体验
			--
			-- 处理方式:
			--   • 不主动对 Markdown 调用 vim.treesitter.start()
			--   • 如果其他插件或 runtime 启动了 Markdown Tree-sitter，则尝试停止
			--   • 清空 indentexpr
			--   • 关闭 conceal
			--

			local function setup_markdown_behavior(args)
				vim.bo.indentexpr = ""
				vim.bo.autoindent = true
				vim.bo.smartindent = false

				-- 避免 markdown 链接、代码块、符号被隐藏
				vim.wo.conceallevel = 0

				-- 防止其他插件自动启动 markdown treesitter
				vim.schedule(function()
					if args and args.buf then
						pcall(vim.treesitter.stop, args.buf)
					end
				end)
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserMarkdownTreesitterFix", {
					clear = true,
				}),
				pattern = {
					"markdown",
				},
				callback = setup_markdown_behavior,
			})

			-- 如果当前 buffer 已经是 Markdown，立即应用一次
			if vim.bo.filetype == "markdown" then
				setup_markdown_behavior({
					buf = vim.api.nvim_get_current_buf(),
				})
			end
		end,
	},
}
