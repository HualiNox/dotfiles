/**
  minipc 的 Home Manager 用户入口。

  导入通用 home 模块，并启用当前用户需要的 CLI 与 IDE 配置。
*/
{ hostConfig, ... }:

{
  imports = [ ../../modules/home/default.nix ];

  home = {
    username = hostConfig.user.name;
    homeDirectory = hostConfig.user.homeDirectory;
  };

  modules = hostConfig.homeModules;
}
