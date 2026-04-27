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
  hasNoctaliaShell = options.programs ? "noctalia-shell";
in
{
  options.meadow.programs.quickshell = {
    enable = mkEnableOption "Wether to create quickshell custom theme";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      warnings = lib.optional (!hasNoctaliaShell) ''
        meadow.programs.quickshell.enable requires inputs.noctalia.homeModules.default.
        Either import that module in the active profile or disable meadow.programs.quickshell.
      '';
    }
    (lib.optionalAttrs hasNoctaliaShell {
      programs = {
        "noctalia-shell" = {
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
            # "SUPER, D, exec, noctalia-shell ipc call spotlight toggle"
            "SUPER, C, global, caelestia:clearNotifs"
            "SUPER, L, global, caelestia:lock"

            "SUPERSHIFT, S, exec, noctalia-shell screenshot"
          ];
        };
      };
    })
  ]);
}
