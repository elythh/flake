{ lib, ... }:
with lib;
{
  imports = lib.meadow.readSubdirs ./.;
  options.meadow.default.terminal = mkOption {
    type = types.enum [
      "wezterm"
      "foot"
      "kitty"
    ];
    default = "wezterm";
  };
}
