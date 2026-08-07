{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = osConfig.modules.desktop.enable && osConfig.modules.desktop.niri.enable;

  fetchPlugin =
    {
      owner,
      repo,
      rev,
      hash,
      subdir ? null,
    }:
    let
      source = pkgs.fetchFromGitHub {
        inherit
          owner
          repo
          rev
          hash
          ;
      };
    in
    if subdir == null then source else source + "/${subdir}";
in
{
  config = lib.mkIf cfg {
    programs.dank-material-shell.plugins = {
      catWidget = {
        src = fetchPlugin {
          owner = "xi-ve";
          repo = "cat-dms";
          rev = "eb7b5138b672be3c06445dd80de6bc30c3076030";
          hash = "sha256-KD2G805Hq0K9aPW9Aq4hNo2XKji4kzdc24M4AcRhsPk=";
        };
      };

      dockerManager = {
        src = fetchPlugin {
          owner = "LuckShiba";
          repo = "DmsDockerManager";
          rev = "255f46794b6e3a5f5e842fe1330db3869deddc09";
          hash = "sha256-YDCwXF0dyuNy07voKvkLlKfHFfPkhSS4oGopn+EnM+0=";
        };
      };

      ipIndicator = {
        src = fetchPlugin {
          owner = "hthienloc";
          repo = "dms-ipIndicator";
          rev = "f9761382c4b8504615e749dea48fd545e24e8fd9";
          hash = "sha256-nbNS00WCSyLfaxT47xSS17GosZK49sbLIw75rkZmgr8=";
        };
      };

      networkIndicator = {
        src = fetchPlugin {
          owner = "gemb0-0";
          repo = "Network-Indicator";
          rev = "619a5526ba4bd0eb5921b96c7c46848faba8f0e7";
          hash = "sha256-fUeT84rpKhmWQ9y44zoJH+xooo0DQVIyLe6SAmpFThk=";
        };
      };

      nixPackageRunner = {
        src = fetchPlugin {
          owner = "iahccc";
          repo = "NixPackageRunner";
          rev = "829ad93c15b7c0ec82a6d7483728029037442601";
          hash = "sha256-ur+1oN+QmTu7p5ZMpL3rCd4JGYbkerko4twa+tH6uvg=";
        };
        settings = {
          terminal = "ghostty";
        };
      };

      systemMonitorPlus = {
        src = fetchPlugin {
          owner = "Dadangdut33";
          repo = "dms-plugins";
          rev = "63fe6b87c497f1f7c2ea61432716817db1c5c3a4";
          hash = "sha256-/iIqBej8dFwOQpvO9PXFvnDwZMSA7IykzaQjl5xoJUs=";
          subdir = "SystemMonitorPlus";
        };
        settings = {
          cpuTempEnabled = true;
          diskPartitionUsageEnabled = true;
          networkSpeedEnabled = false;
          ramUsageEnabled = true;
        };
      };
    };

    home.packages = with pkgs; [
      curl
      imagemagick
      jq
    ];
  };
}
