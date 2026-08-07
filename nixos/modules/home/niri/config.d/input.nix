{ ... }:

{
  programs.niri.settings.input = {
    keyboard = {
      numlock = true;

      xkb.layout = "us";
    };

    touchpad = {
      tap = true;
      natural-scroll = true;
    };

    mouse = {
      natural-scroll = false;
      accel-profile = "flat";
      accel-speed = 0.0;
    };

    focus-follows-mouse = {
      enable = true;
      max-scroll-amount = "0%";
    };
  };
}
