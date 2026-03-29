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
      in
      {
        enable = true;

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
