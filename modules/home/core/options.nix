{lib, ...}:
with lib; {
  options.wallpaper = mkOption {
    type = types.path;
    default = "";
  };
  options.theme = mkOption {
    type = types.str;
    default = "";
  };
}
