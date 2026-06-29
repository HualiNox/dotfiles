{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # android
    android-tools
    usbutils
  ];

  users.groups.adbusers = { };
  users.users.hualimao.extraGroups = [ "adbusers" ];

  services.udev.extraRules = ''
    # Allow adb from remote shells that do not receive logind uaccess ACLs.
    SUBSYSTEM=="usb", ENV{ID_DEBUG_APPLIANCE}=="android", MODE="0660", GROUP="adbusers", TAG+="uaccess"
  '';
}
