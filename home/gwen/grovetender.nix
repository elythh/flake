{ inputs, pkgs, ... }:
{
  theme = "mountain";

  imports = [
    inputs.anyrun.homeManagerModules.default
    ../../modules/home
  ];

  modules = {
    anyrun.enable = true;
    hyprland.enable = true;
    k9s.enable = true;
    lazygit.enable = true;
    rofi.enable = true;
    rbw.enable = true;
    spicetify.enable = true;
    sss.enable = false;
    zellij.enable = true;
    zsh.enable = true;
    hyprpaper.enable = false;
    gpg-agent.enable = true;
  };

  default = {
    de = "hyprland";
    bar = "ags";
    lock = "hyprlock";
    terminal = "foot";
  };

  home = {
    packages = with pkgs; [
      vesktop
      scrcpy
      stremio
      yazi
      showmethekey
    ];
  };
}
