{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  desktopCfg = config.modules.desktop.enable;
  cfg = config.modules.desktop.fcitx5.enable;

  rime-ice = pkgs.fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "2026.06.30";
    hash = "sha256-HReBFYih39ohqZ2UAX6wPjjh0KuIauJPSOjk6ZXidss=";
  };
in
{
  options.modules.desktop.fcitx5.enable = mkEnableOption "Fcitx5 input method";

  config = mkIf (desktopCfg && cfg) {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        waylandFrontend = true;

        addons = [
          (pkgs.fcitx5-rime.override {
            rimeDataPkgs = [ rime-ice ];
          })
        ];

        settings.inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "rime";
          };

          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };

          "Groups/0/Items/1" = {
            Name = "rime";
            Layout = "";
          };

          GroupOrder."0" = "Default";
        };
      };
    };
  };
}
