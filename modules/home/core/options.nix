{ lib, ... }:
with lib;
{
  options.meadow.wallpaper = mkOption {
    type = types.path;
    default = "";
  };
  options.meadow.theme = mkOption {
    type = types.str;
    default = "";
  };
  options.meadow.polarity = mkOption {
    type = types.str;
    default = "dark";
  };
}
