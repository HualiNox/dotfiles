# detect.zsh：导出平台/发行版/WSL 标识

typeset -gx ZSH_PLATFORM="unknown"
typeset -gx ZSH_DISTRO="unknown"
typeset -gx ZSH_IS_WSL=0

case "$(uname -s 2>/dev/null)" in
    Darwin) ZSH_PLATFORM="macos" ;;
    Linux)  ZSH_PLATFORM="linux" ;;
esac

if [[ "$ZSH_PLATFORM" == "linux" ]]; then
    if [[ -e /etc/NIXOS ]]; then
        ZSH_DISTRO="nixos"
    elif [[ -e /etc/arch-release ]]; then
        ZSH_DISTRO="arch"
    elif [[ -e /etc/fedora-release ]]; then
        ZSH_DISTRO="fedora"
    elif [[ -e /etc/debian_version ]]; then
        ZSH_DISTRO="debian"
    fi

    if [[ -r /proc/version ]]; then
        typeset _zsh_proc_version
        _zsh_proc_version="$(< /proc/version)"
        [[ "${_zsh_proc_version:l}" == *microsoft* ]] && ZSH_IS_WSL=1
        unset _zsh_proc_version
    fi
fi
