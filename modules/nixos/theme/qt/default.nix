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

  cfg = config.${namespace}.theme.qt;
in
{
  options.${namespace}.theme.qt = {
    enable = mkBoolOpt false "Whether to customize qt and apply themes.";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [ kdePackages.qtwayland ];
    };

    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };
  };
}
