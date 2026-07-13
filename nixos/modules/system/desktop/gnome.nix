/**
  GNOME 桌面模块。

  仅在 desktop 与 gnome 开关同时启用时加载 GDM、GNOME、ibus 和常用桌面工具。
*/
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkAfter mkEnableOption mkIf;
  cfg = config.modules.desktop.gnome.enable;
  desktopCfg = config.modules.desktop.enable;
  desktopLocale = "zh_CN.UTF-8";
  gnomeChineseSession =
    pkgs.runCommand "gnome-zh-session"
      {
        passthru.providedSessions = [ "gnome-zh" ];
      }
      ''
        mkdir -p $out/bin $out/share/wayland-sessions

        cat > $out/bin/gnome-zh-session <<'EOF'
        #!${pkgs.bash}/bin/bash
        export LANG=${desktopLocale}
        export LC_MESSAGES=${desktopLocale}
        export LANGUAGE=zh_CN:zh

        ${config.systemd.package}/bin/systemctl --user import-environment LANG LC_MESSAGES LANGUAGE || true
        ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd LANG LC_MESSAGES LANGUAGE || true

        exec ${pkgs.gnome-session}/bin/gnome-session "$@"
        EOF
        chmod +x $out/bin/gnome-zh-session

        cat > $out/share/wayland-sessions/gnome-zh.desktop <<EOF
        [Desktop Entry]
        Name=GNOME (Chinese)
        Name[zh_CN]=GNOME（中文）
        Comment=This session logs you into GNOME with Chinese locale
        Exec=$out/bin/gnome-zh-session
        TryExec=$out/bin/gnome-zh-session
        Type=Application
        DesktopNames=GNOME
        X-GDM-SessionRegisters=true
        X-GDM-CanRunHeadless=true
        EOF
      '';
in
{
  # GNOME 是 desktop 的子开关，避免未启用桌面时单独拉起图形栈。
  options.modules.desktop.gnome.enable = mkEnableOption "GNOME desktop configuration";

  config = mkIf (cfg && desktopCfg) {

    services = {
      xserver.enable = true;

      displayManager = {
        gdm.enable = true;
        defaultSession = "gnome-zh";
        sessionPackages = mkAfter [ gnomeChineseSession ];
      };
      desktopManager.gnome.enable = true;
      gnome = {
        core-apps.enable = false;
        sushi.enable = true;
        gnome-keyring.enable = true;
      };
    };

    # ibus 中文输入法，使用雾凇拼音 Rime 数据源与 libpinyin 覆盖主要中文输入场景。
    i18n.inputMethod = {
      enable = true;
      type = "ibus";

      ibus.engines = with pkgs.ibus-engines; [
        (rime.override {
          rimeDataPkgs = [ pkgs.rime-ice ];
        })
        libpinyin
      ];
    };

    security.polkit.enable = true;

    # 系统级桌面工具和 GNOME 集成组件。
    environment = {
      systemPackages = with pkgs; [
        # 终端与字体
        ghostty
        nerd-fonts.jetbrains-mono

        # 剪贴板
        wl-clipboard

        # GNOME 常用工具
        nautilus
        file-roller
        gnome-system-monitor
        baobab
        gnome-calculator
        gnome-tweaks
        gnome-menus

        # 缩略图
        ffmpegthumbnailer
      ];

      # 让 Nautilus 找到系统路径中的扩展
      sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
      pathsToLink = [ "/share/nautilus-python/extensions" ];
    };

    # GNOME Disks 需要配套 D-Bus 服务，使用模块开关比只安装包更完整。
    programs.gnome-disks.enable = true;

    xdg.mime.defaultApplications = {
      "inode/directory" = [
        "nautilus.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    # U 盘、移动硬盘等
    services.udisks2.enable = true;

  };

}
