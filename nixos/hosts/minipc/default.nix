/**
  minipc 系统主机入口。

  绑定硬件配置、Home Manager 用户入口和当前主机启用的系统功能。
*/
{
  home-manager,
  inputs,
  ...
}:

{
  imports = [
    ../../modules/system/default.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];

  networking.hostName = "catserver";

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs; };
    users.hualimao = ./home.nix;
  };

  modules = {
    desktop = {
      enable = true;
      fcitx5.enable = true;
      hyprland.enable = true;
    };

    mihomo.enable = true;
    buildkite.enable = true;
  };
}
