{
  lib,
  config,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.meadow.programs.quickshell;
in
{
  options.meadow.programs.quickshell = {
    enable = mkEnableOption "Wether to create quickshell custom theme";
  };

  config = mkIf cfg.enable {
    programs.dank-material-shell.enable = true;
    programs.dank-material-shell = {
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
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "SUPER, D, exec, dms ipc call spotlight toggle"
          "SUPER, C, global, caelestia:clearNotifs"
          "SUPER, L, global, caelestia:lock"

          "SUPERSHIFT, S, exec, dms screenshot"
        ];
      };
    };
  };
}
