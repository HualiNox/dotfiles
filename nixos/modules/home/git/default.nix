/**
  Git 配置模块。

  Git 基础配置默认开启，保证所有 Home Manager 环境都有可用的 Git；
  git-ext 只负责额外工具和扩展能力，开启后额外启用 Git LFS、repo 和 Commitizen。
*/
{
  pkgs,
  lib,
  config,
  ...
}:

{
  # 扩展开关只控制可选工具，避免基础 Git 配置依赖额外选项。
  options.modules.git-ext.enable = lib.mkEnableOption "extended Git tools and configuration";

  config = {
    programs.git = {
      # 基础 Git 始终启用，提交身份和常用配置在这里集中维护。
      enable = true;

      # LFS 按需启用，适合需要处理大文件仓库的开发环境。
      lfs.enable = config.modules.git-ext.enable;

      settings = {
        # 默认提交身份，会写入 home-manager 管理的 ~/.config/git/config。
        user = {
          name = "HualiNox";
          email = "hualinox@gmail.com";
        };
      };
    };

    # repo 与 Commitizen 属于项目协作工具，只在 git-ext 打开时安装。
    home.packages = lib.mkIf config.modules.git-ext.enable (
      with pkgs;
      [
        git-repo
        commitizen
      ]
    );
  };
}
