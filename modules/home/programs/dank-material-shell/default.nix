{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkMerge;

  cfg = config.meadow.programs.dank-material-shell;
  active = cfg.enable || config.meadow.programs.shell == "dank-material-shell";
  hasDmsShell = options.programs ? "dank-material-shell";
in
{
  options.meadow.programs.dank-material-shell = {
    enable = mkEnableOption "Whether to enable the DankMaterialShell module";
  };

  config = mkIf active (mkMerge [
    {
      warnings = lib.optional (!hasDmsShell) ''
        meadow.programs.dank-material-shell.enable (or meadow.programs.shell = "dank-material-shell") requires inputs.dms.homeModules.dank-material-shell.
        Either import that module in the active profile or select another shell.
      '';
    }
    (lib.optionalAttrs hasDmsShell {
      programs.dank-material-shell = {
        enable = true;
        systemd = {
          enable = true;
        };
      };
    })
  ]);
}
