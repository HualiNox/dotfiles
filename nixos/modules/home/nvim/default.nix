/**
  Neovim Home Manager 模块。

  启用 Neovim 及其外部依赖，真实编辑器配置由仓库中的 Lua 配置负责。
*/
{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

{
  # 主机用户入口按需开启，避免服务器环境默认安装完整编辑器工具链。
  options.modules.nvim = {
    enable = mkEnableOption "nvim";
  };

  config = mkIf config.modules.nvim.enable {
    home.packages = with pkgs; [
      # lazy.nvim / 插件管理
      git
      curl
      wget
      unzip
      gnutar
      gzip

      # treesitter 编译
      # tree-sitter
      gcc
      gnumake
      pkg-config

      # 常用外部工具
      ripgrep
      fd
      fzf
      bat
      eza
      lazygit

      # 语言运行时 / Mason 常用
      nodejs
      python3
      go
      rustup
      jdk21

      #
      nixd
      nixfmt

      # 剪贴板
      xclip
      wl-clipboard
    ];

    programs.neovim = {
      enable = true;

      # 让 EDITOR、vi/vim/vimdiff 都指向同一套 Neovim 配置。
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      sideloadInitLua = true;
    };

  };
}
