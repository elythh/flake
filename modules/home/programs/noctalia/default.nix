{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkMerge;

  cfg = config.meadow.programs.noctalia;
  active = cfg.enable || config.meadow.programs.shell == "noctalia";
  hasNoctaliaShell = options.programs ? noctalia;
in
{
  options.meadow.programs.noctalia = {
    enable = mkEnableOption "Whether to enable the Noctalia shell module";
  };

  config = mkIf active (mkMerge [
    {
      warnings = lib.optional (!hasNoctaliaShell) ''
        meadow.programs.noctalia.enable (or meadow.programs.shell = "noctalia") requires inputs.noctalia.homeModules.default.
        Either import that module in the active profile or select another shell.
      '';
    }
    (lib.optionalAttrs hasNoctaliaShell {
      programs = {
        noctalia = {
          enable = true;
          systemd = {
            enable = true;
          };
        };
      };
    })
  ]);
}
