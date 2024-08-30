{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.theme.gtk;
in
{
  options.${namespace}.theme.gtk = {
    enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
  };

  config = mkIf cfg.enable {
    services = {
      udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    };
  };
}
