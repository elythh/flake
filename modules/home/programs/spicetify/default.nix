{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (inputs) spicetify;

  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.meadow.programs.spicetify;
in
{
  imports = [ spicetify.homeManagerModules.default ];
  options.meadow.programs.spicetify = {
    enable = mkEnableOption "Wether to enable Spicetify";
  };

  config = mkIf cfg.enable {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        colors = config.lib.stylix.colors;
      in
      {
        enable = true;

        theme = spicePkgs.themes.text;

        customColorScheme = {
          text = colors.base05;
          subtext = colors.base04;
          main = colors.base00;
          header = colors.base03;
          highlight = colors.base02;
          accent = colors.base0D;
          "accent-active" = colors.base0C;
          "accent-inactive" = colors.base02;
          banner = colors.base0D;
          "border-active" = colors.base0D;
          "border-inactive" = colors.base03;
          notification = colors.base0D;
          "notification-error" = colors.base08;
        };

        enabledExtensions = with spicePkgs.extensions; [
          adblock
          hidePodcasts
          shuffle # shuffle+ (special characters are sanitized out of extension names)
        ];
        enabledCustomApps = with spicePkgs.apps; [
          newReleases
          ncsVisualizer
        ];
        enabledSnippets = with spicePkgs.snippets; [
          rotatingCoverart
          pointer
        ];
      };
  };
}
