# zi.zsh：Zi 插件管理器自举

typeset -gx ZI_HOME="${ZI_HOME:-$HOME/.config/zsh/zi}"
typeset -gx ZI_BIN_DIR="${ZI_BIN_DIR:-$ZI_HOME/bin}"

# 兼容 Zi 旧版关联数组接口
typeset -gA ZI
ZI[HOME_DIR]="$ZI_HOME"
ZI[BIN_DIR]="$ZI_BIN_DIR"

# 自举：仅在 Zi 未安装时通过 git clone 安装。
if [[ ! -f "$ZI_BIN_DIR/zi.zsh" ]]; then
    if command -v git >/dev/null 2>&1; then
        mkdir -p "$ZI_HOME"
        git clone https://github.com/z-shell/zi.git "$ZI_BIN_DIR" \
            || print -u2 -- "[zi] clone failed, plugins will be skipped"
    else
        print -u2 -- "[zi] git not found, skipping bootstrap"
    fi
fi

if [[ -f "$ZI_BIN_DIR/zi.zsh" ]]; then
    source "$ZI_BIN_DIR/zi.zsh"
fi
