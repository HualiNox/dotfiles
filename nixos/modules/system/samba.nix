/** 两个 SMB 共享分别对应两块机械盘。 */
{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  vetoFiles = "/._*/.DS_Store/.AppleDouble/.AppleDB/.AppleDesktop/.TemporaryItems/.Trashes/Thumbs.db/ehthumbs.db/Desktop.ini/$RECYCLE.BIN/System Volume Information/";
  shareSettings = path: {
    inherit path;
    browseable = "yes";
    "read only" = "no";
    "valid users" = "hualimao";
    "force group" = "fileshare";
    "create mask" = "0660";
    "directory mask" = "2770";
    "vfs objects" = "catia fruit streams_xattr";
    "ea support" = "yes";
    "veto files" = vetoFiles;
    "delete veto files" = "yes";
  };
in
{
  options.modules.samba.enable = mkEnableOption "Samba file sharing";

  config = mkIf config.modules.samba.enable {
    users.groups.fileshare = { };
    users.users.hualimao.extraGroups = [ "fileshare" ];

    services.samba = {
      enable = true;
      nmbd.enable = false;
      settings = {
        global = {
          workgroup = "WORKGROUP";
          security = "user";
          "map to guest" = "Never";
          "server min protocol" = "SMB2";
        };

        "hdd-a" = shareSettings "/srv/storage/hdd-a";
        "hdd-b" = shareSettings "/srv/storage/hdd-b";
      };
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    networking.firewall.allowedTCPPorts = [ 445 ];

    systemd.tmpfiles.rules = [
      "d /srv/storage 0755 root root -"
      "d /srv/storage/hdd-a 2770 root fileshare -"
      "d /srv/storage/hdd-b 2770 root fileshare -"
    ];
  };
}
