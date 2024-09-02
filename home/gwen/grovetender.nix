{ inputs, pkgs, ... }:
{
  theme = "mountain";

  imports = [
    inputs.stylix.homeManagerModules.stylix
    inputs.anyrun.homeManagerModules.default
    ../../modules/home
  ];

  opt = {
    browser = {
      firefox.enable = true;
    };
    misc = {
      obsidian.enable = true;
      yamlfmt.enable = true;
      rbw.enable = true;
    };
    music = {
      spicetify.enable = true;
    };
  };

  modules = {
    anyrun.enable = true;
    hyprland.enable = true;
    k9s.enable = true;
    lazygit.enable = true;
    rofi.enable = true;
    sss.enable = false;
    zellij.enable = true;
    zsh.enable = true;
    hyprpaper.enable = false;
    gpg-agent.enable = true;
  };

  default = {
    de = "hyprland";
    bar = "waybar";
    lock = "hyprlock";
    terminal = "foot";
  };

  home = {
    packages = with pkgs; [
      android-tools
      vesktop
      scrcpy
      stremio
      yazi
      lunar-client
      wdisplays
    ];
  };
}
