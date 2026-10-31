{ config, lib, ... }:
{
  programs.hyprland = lib.mkIf (lib.elem "hyprland" config.meadow.wms) {
    enable = true;
    xwayland.enable = true;
  };
}
