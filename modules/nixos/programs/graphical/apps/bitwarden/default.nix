{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption;

  cfg = config.${namespace}.programs.graphical.apps.bitwarden;
in
{
  options.${namespace}.programs.graphical.apps.bitwarden = {
    enable = mkEnableOption "Wether or not to enable bitwarden";
  };
  config = lib.mkIf cfg {
    environment.systemPackages = with pkgs; [ bitwarden ];
  };
}
