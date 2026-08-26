# init.zsh：模块加载入口

# 仅在交互式 shell 加载完整配置
[[ -o interactive ]] || return

# p10k instant prompt 尽量靠前
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_CONFIG_HOME="${ZSH_CONFIG_HOME:-$HOME/.config/zsh}"

_zsh_load() {
	local f="$ZSH_CONFIG_HOME/$1"
	[[ -r "$f" ]] && source "$f"
}

_zsh_load detect.zsh
_zsh_load utils.zsh
_zsh_load path.zsh
_zsh_load env.zsh

# 平台分流
case "$ZSH_PLATFORM" in
macos) _zsh_load os/macos.zsh ;;
linux)
	_zsh_load os/linux.zsh
	[[ "$ZSH_DISTRO" == "nixos" ]] && _zsh_load os/nixos.zsh
	;;
esac

_zsh_load zi.zsh
_zsh_load theme.zsh
_zsh_load aliases.zsh
_zsh_load history.zsh
_zsh_load plugins.zsh
_zsh_load terminal.zsh

# 本机私有配置（不提交）
_zsh_load local.zsh

unset -f _zsh_load
