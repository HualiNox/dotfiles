# plugins.zsh：zi 插件加载（不可用时直接跳过）

# zi 不可用 → 安静返回，不阻塞 shell
(( ${+functions[zi]} )) || return

# EDITOR=nvim 会使 Zsh 默认选用 viins；统一使用 Emacs 命令行键位。
bindkey -e

# 初始化 zi 自身的补全体系
zicompinit
zi light z-shell/z-a-meta-plugins

# 常用 CLI 的社区补全集合。
zi light zsh-users/zsh-completions

# 延迟加载非关键插件
zi ice wait lucid atinit='zpcompinit'
zi ice wait lucid
zi light z-shell/z-a-bin-gem-node

# fzf-tab 依赖 Zi 的补全体系
zi ice wait lucid
zi light Aloxaf/fzf-tab

# 仅当存在 eza 时加载 zsh-eza
if [[ -n "$EZA_BIN" ]]; then
    zi ice wait lucid
    zi light z-shell/zsh-eza
fi

# alias 提示
zi ice wait lucid
zi light MichaelAquilina/zsh-you-should-use

# 自动补全成对字符
zi ice wait lucid
zi light hlissner/zsh-autopair

# 仅在已安装 direnv 时注入其 zsh hook
if command_exists direnv; then
    eval "$(direnv hook zsh)"
fi

# OMZ snippets
zi snippet OMZL::git.zsh
zi snippet OMZP::git
zi snippet OMZP::sudo
zi snippet OMZP::vscode

# autosuggestions 优先于 syntax-highlighting 加载
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
zi ice wait lucid
zi light zsh-users/zsh-autosuggestions
zi ice wait lucid
zi light zsh-users/zsh-syntax-highlighting

# macOS 专属插件示例（按需放在此处）
# if [[ "$ZSH_PLATFORM" == "macos" ]]; then
#     zi ice wait lucid
#     zi light some/macos-only-plugin
# fi
