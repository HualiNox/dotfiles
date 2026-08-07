/**
  系统公共服务配置。

  配置基础网络、蓝牙与 OpenSSH。
*/
{ ... }:

{
  # 网络与蓝牙
  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # openssh 配置
  services = {
    blueman.enable = true;
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";

        # 只允许明确列出的本地账号通过 SSH 登录。
        AllowUsers = [
          "hualimao"
        ];
      };

    };
  };
}
