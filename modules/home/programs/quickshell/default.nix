{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkMerge;

  cfg = config.meadow.programs.caelestia;
  hasCaelestiaShell = options.programs ? caelestia;
in
{
  options.meadow.programs.caelestia = {
    enable = mkEnableOption "Whether to enable the Caelestia shell module";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      warnings = lib.optional (!hasCaelestiaShell) ''
        meadow.programs.caelestia.enable requires inputs.caelestia.homeManagerModules.default.
        Either import that module in the active profile or disable meadow.programs.caelestia.
      '';
    }
    (lib.optionalAttrs hasCaelestiaShell {
      programs = {
        caelestia = {
          enable = true;
          systemd = {
            enable = true;
          };
          settings = {
            showWorkspaceIndex = true;
            showWorkspaceApps = true;
            osdPosition = 6;
            workspaceAppIconSizeOffset = 3;
          };
        };
      };
      wayland.windowManager.hyprland = {
        settings = {
          bind = [
            # "SUPER, D, exec, caelestia-shell ipc call spotlight toggle"
            "SUPER, C, global, caelestia:clearNotifs"
            "SUPER, L, global, caelestia:lock"

            "SUPERSHIFT, S, exec, caelestia-shell screenshot"
          ];
        };
      };
    })
  ]);
}
