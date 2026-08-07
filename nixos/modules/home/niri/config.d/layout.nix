{ ... }:

{
  programs.niri.settings.layout = {
    center-focused-column = "never";

    preset-column-widths = [
      { proportion = 0.33333; }
      { proportion = 0.5; }
      { proportion = 0.66667; }
      { proportion = 1.0; }
    ];

    default-column-width.proportion = 0.5;

    shadow = {
      enable = true;
      softness = 20;
      spread = 10;
      offset = {
        x = 0;
        y = 0;
      };
      color = "#0007";
    };
  };
}
