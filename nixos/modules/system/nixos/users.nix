/**
  系统用户与 shell 配置。

  创建主用户、授予常用管理组，并在系统层启用 zsh。
*/
{ pkgs, ... }:

{
  # 用户配置
  users.users.hualimao = {
    description = "HuaLiMao-AQ";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # 平台配置
  programs.zsh.enable = true;
}
