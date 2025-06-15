{ lib, ... }:
{
  imports = lib.meadow.readSubdirs ./.;
  options.meadow.default.terminal = lib.mkOption {
    type = lib.types.enum [
      "wezterm"
      "foot"
      "kitty"
    ];
    default = "wezterm";
  };
}
