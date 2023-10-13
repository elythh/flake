{ config, lib, pkgs, hyprland, colors, ... }:

{
  programs.waybar =
    with colors;{
      enable = true;
      package = pkgs.waybar;
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
    };
}
