{
  lib,
  config,
  inputs,
  pkgs,
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
    home.packages = with pkgs; [
      inputs.quickshell.packages."${pkgs.system}".quickshell

      lm_sensors
      ddcutil
      ibm-plex
      material-symbols
      nerd-fonts.jetbrains-mono
      xdg-user-dirs
      swappy
    ];

    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "SUPER, D, global, caelestia:launcher"
          "SUPER, C, global, caelestia:clearNotifs"
          "SUPER, L, global, caelestia:lock"

          "SUPERSHIFT, S, global, caelestia:screenshot"
        ];
      };
    };
  };
}
