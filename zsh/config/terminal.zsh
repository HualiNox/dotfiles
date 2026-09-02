# terminal.zsh：终端集成

# mise 配置
if command_exists mise; then
  eval "$(mise activate zsh)"
fi

# zoxide 配置
if command_exists zoxide; then
  eval "$(zoxide init zsh)"
fi
