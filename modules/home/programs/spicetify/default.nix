{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (inputs) spicetify;

  inherit
    (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.meadow.programs.spicetify;
in {
  imports = [spicetify.homeManagerModules.default];
  options.meadow.programs.spicetify = {
    enable = mkEnableOption "Wether to enable Spicetify";
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
    };
  };
}
