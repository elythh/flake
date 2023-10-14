{ config, lib, pkgs, hyprland, colors, ... }:

{
  programs.waybar =
    with colors;{
      enable = true;
      package = pkgs.waybar;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
    };
}
