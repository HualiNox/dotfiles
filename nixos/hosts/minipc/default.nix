/**
  minipc 系统主机入口。

  绑定硬件配置、Home Manager 用户入口和当前主机启用的系统功能。
*/
{
  home-manager,
  inputs,
  ...
}:

let
  hostConfig = import ./host-config.nix;
in
{
  imports = [
    ../../modules/system/default.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];

  networking.hostName = hostConfig.hostName;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      inherit inputs hostConfig;
    };
    users.${hostConfig.user.name} = ./home.nix;
  };

  modules = hostConfig.systemModules;
}
