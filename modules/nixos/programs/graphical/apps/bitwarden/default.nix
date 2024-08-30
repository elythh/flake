{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.graphical.apps.bitwarden;
in
{
  options.${namespace}.programs.graphical.apps.bitwarden = {
    enable = mkEnableOption "Wether or not to enable bitwarden";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bitwarden ];
  };
}
