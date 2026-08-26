/** WTR Pro 主机入口。 */
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
