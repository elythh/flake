{ lib, ... }:
{
  imports = lib.meadow.readSubdirs ./.;
  options.meadow.default.wm = lib.mkOption {
    type = lib.types.enum [
      "niri"
      "hyprland"
    ];
    default = "hyprland";
  };
}
