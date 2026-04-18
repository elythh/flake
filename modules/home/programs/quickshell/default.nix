{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkMerge;

  cfg = config.meadow.programs.quickshell;
  hasDankMaterialShell = options.programs ? "dank-material-shell";
in
{
  options.meadow.programs.quickshell = {
    enable = mkEnableOption "Wether to create quickshell custom theme";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      warnings = lib.optional (!hasDankMaterialShell) ''
        meadow.programs.quickshell.enable requires inputs.dms.homeModules.dank-material-shell.
        Either import that module in the active profile or disable meadow.programs.quickshell.
      '';
    }
    (lib.optionalAttrs hasDankMaterialShell {
      programs = {
        "dank-material-shell" = {
          enable = true;
          systemd = {
            enable = true;
            restartIfChanged = true;
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
            # "SUPER, D, exec, dms ipc call spotlight toggle"
            "SUPER, C, global, caelestia:clearNotifs"
            "SUPER, L, global, caelestia:lock"

            "SUPERSHIFT, S, exec, dms screenshot"
          ];
        };
      };
    })
  ]);
}
