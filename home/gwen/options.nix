# options.nix
{ lib, ... }:
with lib; {
  options.theme.wallpaper = mkOption {
    type = types.string;
    default = "";
  };
}
