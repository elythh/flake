# options.nix
{ lib, ... }:
with lib; {
  options.wallpaper = mkOption {
    type = types.path;
    default = "";
  };
}
