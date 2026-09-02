/**
  GEM12 Max 系统主机入口。

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
    ../../modules/system/desktop/fcitx5.nix
    ../../modules/system/desktop/niri.nix
    ./boot.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];

  networking.hostName = hostConfig.hostName;

  # AMD 核显使用内核 amdgpu 与 Mesa 图形栈。
  hardware.graphics.enable = true;

  # 机器有 58 GiB 内存，降低正常负载下主动换出内存的倾向。
  boot.kernel.sysctl."vm.swappiness" = 10;

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

  # 通过 NixOS specialisation 临时启用 Mihomo，默认配置保持关闭。
  specialisation.mihomo.configuration.modules.mihomo.enable = true;
}
