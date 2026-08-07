{ ... }:

let
  spring = {
    damping-ratio = 0.8;
    stiffness = 400;
    epsilon = 0.0001;
  };
in
{
  programs.niri.settings.animations = {
    slowdown = 0.9;

    workspace-switch.kind.spring = {
      damping-ratio = 0.82;
      stiffness = 523;
      epsilon = 0.0001;
    };

    horizontal-view-movement.kind.spring = {
      damping-ratio = 0.86;
      stiffness = 423;
      epsilon = 0.0001;
    };

    window-open.kind.easing = {
      duration-ms = 350;
      curve = "cubic-bezier";
      curve-args = [
        0.05
        0.9
        0.1
        1.05
      ];
    };

    window-close.kind.easing = {
      duration-ms = 150;
      curve = "ease-out-quad";
      curve-args = [ ];
    };

    window-movement.kind.spring = spring;
    window-resize.kind.spring = spring;
    overview-open-close.kind.spring = spring;
  };
}
