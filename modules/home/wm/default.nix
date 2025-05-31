{lib, ...}:
with lib; {
  imports = lib.meadow.readSubdirs ./.;
  options.meadow.default.wm = mkOption {
    type = types.enum [
      "niri"
      "hyprland"
    ];
    default = "hyprland";
  };
}
