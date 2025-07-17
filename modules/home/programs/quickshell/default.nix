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
    home.packages = [
      # inputs.quickshell.packages."${pkgs.system}".quickshell
      inputs.caelestia-cli.packages."${pkgs.system}".default
      inputs.caelestia.packages."${pkgs.system}".default
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
