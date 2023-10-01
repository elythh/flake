{ config, lib, pkgs, hyprland, colors, ... }:

{
  programs.waybar =
    with colors;{
      enable = true;
      # package = hyprland.packages.${pkgs.system}.waybar-hyprland;
      package = pkgs.waybar;
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
    };
}
