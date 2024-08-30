{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkDefault mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.theme.qt;
in
{
  options.${namespace}.theme.qt = {
    enable = mkBoolOpt false "Whether to customize qt and apply themes.";
  };

  config = mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    home = {
      sessionVariables = {
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        DISABLE_QT5_COMPAT = "0";
      };
    };

    qt = {
      enable = true;
      platformTheme = {
        name = "qtct";
      };
      style = mkDefault { name = "qt6ct-style"; };
    };
  };
}
