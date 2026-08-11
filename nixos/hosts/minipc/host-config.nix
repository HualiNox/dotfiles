{
  hostName = "catserver";

  user = {
    name = "hualimao";
    homeDirectory = "/home/hualimao";
  };

  systemModules = {
    desktop = {
      enable = true;
      fcitx5.enable = true;
      niri.enable = true;
    };

    mihomo.enable = true;
    buildkite.enable = true;
  };

  homeModules = {
    desktop.niri.enable = true;
    nvim.enable = true;
    zsh.enable = true;
    git-ext.enable = true;
    tmux.enable = true;
    vscode.enable = true;
  };
}
