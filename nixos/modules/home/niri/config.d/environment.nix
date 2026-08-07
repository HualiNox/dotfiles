{ ... }:

{
  programs.niri.settings.environment = {
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
    QT_IM_MODULES = "wayland;fcitx";
    GTK_IM_MODULE = null;
    SDL_IM_MODULE = null;
    GLFW_IM_MODULE = null;

    TERMINAL = "ghostty";
    NIXOS_OZONE_WL = "1";
  };
}
