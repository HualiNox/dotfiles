/**
  Android 调试工具与 ADB 权限配置。

  安装 adb/usb 工具，并让 hualimao 用户可从远程 shell 访问 Android 设备。
*/
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # android
    android-tools
    usbutils
  ];

  # 远程 shell 不一定拿得到 logind uaccess ACL，使用 adbusers 作为稳定权限入口。
  users.groups.adbusers = { };
  users.users.hualimao.extraGroups = [ "adbusers" ];

  services.udev.extraRules = ''
    # Allow adb from remote shells that do not receive logind uaccess ACLs.
    SUBSYSTEM=="usb", ENV{ID_DEBUG_APPLIANCE}=="android", MODE="0660", GROUP="adbusers", TAG+="uaccess"
  '';
}
