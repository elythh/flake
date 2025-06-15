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
  inherit (lib.lists) concatLists;

  cfg = config.meadow.programs.quickshell;
in
{
  options.meadow.programs.quickshell = {
    enable = mkEnableOption "Wether to create quickshell custom theme";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (inputs.quickshell.packages."${pkgs.system}".quickshell.overrideAttrs (old: {
        buildInputs = concatLists [
          (old.buildInputs or [ ])
          [ python313Packages.materialyoucolor ]
        ];
      }))

      lm_sensors
      ddcutil
      ibm-plex
      material-symbols
      nerd-fonts.jetbrains-mono
      xdg-user-dirs
    ];

    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "SUPER, D, global, caelestia:launcher"
        ];
      };
    };
  };
}
