{
  config,
  lib,
  pkgs,
  ...
}:
let
  hyprland = lib.elem "hyprland" config.meadow.wms;
in
{
  # niri brings its own portal config (gnome + gtk) through programs.niri
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = lib.mkIf hyprland {
      common.default = [ "hyprland" ];
      hyprland.default = [ "hyprland" ];
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ]
    ++ lib.optionals hyprland [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-wlr
    ];
  };
}
