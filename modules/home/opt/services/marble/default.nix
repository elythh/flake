# in home.nix
{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.meadow.opt.services.marble;
in
{

  options.meadow.opt.services.marble.enable = mkEnableOption "marble";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.marble.packages.${system}.default
    ];

  };
}
