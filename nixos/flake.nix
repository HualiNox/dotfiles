/**
  NixOS flake 入口。

  固定系统、Home Manager 与 nix-index 输入源，并通过 mkSystem 组装主机配置。
*/
{
  description = "NixOS system";

  inputs = {
    # 主系统跟随稳定分支，保证系统重建时默认偏保守。
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # 少量桌面应用从 unstable 获取新版本，由具体模块按需引用。
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager 与系统 nixpkgs 对齐，避免用户环境和系统包集版本漂移。
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      ...
    }@inputs:
    let
      # 当前仓库只声明 x86_64-linux 主机；新增架构时从这里扩展。
      system = "x86_64-linux";

      # host 与 hostname 分开配置，避免同一 hostname 配置到同一局域网多台设备
      mkSystem =
        pkgs: system: host: hostname:
        pkgs.lib.nixosSystem {
          system = system;
          modules = [
            { networking.hostName = hostname; }

            # 系统配置文件
            ./modules/system/default.nix

            # 硬件配置文件
            (./. + "/hosts/${host}/hardware-configuration.nix")

            # home-manager
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                backupFileExtension = "hm-backup";
                extraSpecialArgs = { inherit inputs; };
                users.hualimao = (./. + "/hosts/${host}/user.nix");
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
    in
    {
      nixosConfigurations = {
        catserver = mkSystem inputs.nixpkgs system "minipc" "catserver";
      };
    };
}
