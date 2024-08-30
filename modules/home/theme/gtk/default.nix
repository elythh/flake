{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace})
    boolToNum
    mkBoolOpt
    ;

  cfg = config.${namespace}.theme.gtk;
in
{
  options.${namespace}.theme.gtk = {
    enable = mkBoolOpt false "Whether to customize GTK and apply themes.";
    usePortal = mkBoolOpt false "Whether to use the GTK Portal.";
  };

  config = mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    home = {
      packages = with pkgs; [
        dconf
        glib # gsettings
        gtk3.out # for gtk-launch
        libappindicator-gtk3
      ];

      sessionVariables = {
        GTK_USE_PORTAL = "${toString (boolToNum cfg.usePortal)}";
      };
    };

    dconf = {
      enable = true;
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme.override { color = "nordic"; };
      };
    };

  };
}
