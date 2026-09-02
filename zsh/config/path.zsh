# path.zsh：跨平台 PATH 管理
# 依赖 utils.zsh 中的 path_prepend_if_exists / command_exists

# 通用工具链与用户级 bin
path_prepend_if_exists "$HOME/.local/bin"
path_prepend_if_exists "$HOME/bin"

if command_exists mise; then
    path_prepend_if_exists "$HOME/.local/share/mise/shims"
fi
if [[ -x "$HOME/.cargo/bin/cargo" ]]; then
    path_prepend_if_exists "$HOME/.cargo/bin"
fi

# macOS Homebrew：优先 Apple Silicon 路径，再回退 Intel
if [[ "$ZSH_PLATFORM" == "macos" ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # 按存在性挂载常用 Homebrew keg-only 工具
    path_prepend_if_exists "/opt/homebrew/opt/mysql-client/bin"
    path_prepend_if_exists "/opt/homebrew/opt/rustup/bin"
fi
