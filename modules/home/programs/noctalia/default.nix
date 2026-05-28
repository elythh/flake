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
  hasNoctaliaShell = options.programs ? noctalia;
in
{
  options.meadow.programs.noctalia = {
    enable = mkEnableOption "Whether to enable the Noctalia shell module";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      warnings = lib.optional (!hasNoctaliaShell) ''
        meadow.programs.noctalia.enable requires inputs.noctalia.homeModules.default.
        Either import that module in the active profile or disable meadow.programs.noctalia.
      '';
    }
    (lib.optionalAttrs hasNoctaliaShell {
      programs = {
        noctalia = {
          enable = true;
          # You can add settings here once you explore the v5 config options
          # See: https://docs.noctalia.dev/v5/
        };
      };

      # Optional: Add some basic Hyprland keybindings for Noctalia
      # wayland.windowManager.hyprland = {
      #   settings = {
      #     bind = [
      #       # Add Noctalia-specific keybindings here if needed
      #     ];
      #   };
      # };
    })
  ]);
}
