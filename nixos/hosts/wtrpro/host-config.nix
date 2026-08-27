{
  hostName = "catedge";

  user = {
    name = "hualimao";
    homeDirectory = "/home/hualimao";
  };

  # 不启用桌面环境
  systemModules = {
    docker.enable = true;
    tailscale.enable = true;
    samba.enable = true;
    ups = {
      enable = true;
      name = "cyberpower";
      description = "CyberPower UT650EGC";
      vendorId = "0764";
      productId = "0501";
    };
    hddPower = {
      enable = true;
      devices = [
        "/dev/disk/by-id/ata-WDC_WD10EFRX-68FYTN0_WD-WCC4J3039209"
        "/dev/disk/by-id/ata-WDC_WD10EFRX-68FYTN0_WD-WCC4J2VC9HSD"
      ];
    };
  };

  homeModules = {
    direnv.enable = true;
    nvim.enable = true;
    zsh.enable = true;
    git-ext.enable = true;
    tmux.enable = true;
  };
}
