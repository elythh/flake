{
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption;
in
{
  options.${namespace}.programs.graphical.apps.bitwarden = {
    enable = mkEnableOption "Wether or not to enable bitwarden";
  };
}
