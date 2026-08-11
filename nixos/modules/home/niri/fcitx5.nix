{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.modules.desktop.niri.enable;
in
{
  config = mkIf cfg {
    xdg.configFile = {
      "fcitx5/config" = {
        force = true;
        text = ''
          [Behavior/DisabledAddons]
          0=kimpanel

          [Behavior/EnabledAddons]
          0=classicui
        '';
      };

      "fcitx5/profile" = {
        force = true;
        text = ''
          [GroupOrder]
          0=Default

          [Groups/0]
          Default Layout=us
          DefaultIM=rime
          Name=Default

          [Groups/0/Items/0]
          Layout=
          Name=keyboard-us

          [Groups/0/Items/1]
          Layout=
          Name=rime
        '';
      };

      "fcitx5/conf/classicui.conf" = {
        force = true;
        text = ''
          DarkTheme=inflex-youlan-dark
          EnableFractionalScale=True
          Font=Sans 10
          ForceWaylandDPI=0
          MenuFont=Sans 10
          PerScreenDPI=False
          PreferTextIcon=False
          ShowLayoutNameInIcon=True
          Theme=inflex-youlan
          TrayFont=Sans Bold 10
          TrayOutlineColor=#000000
          TrayTextColor=#ffffff
          UseAccentColor=True
          UseDarkTheme=True
          UseInputMethodLanguageToDisplayText=True
          VerticalCandidateList=False
          WheelForPaging=True
        '';
      };
    };
  };
}
