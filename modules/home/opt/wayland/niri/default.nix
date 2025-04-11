{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [
    inputs.niri.homeModules.niri
    ./settings.nix
    ./binds.nix
    ./rules.nix
  ];

  home = mkIf (config.meadow.default.de == "niri") {
    packages = with pkgs; [
      swww
      seatd
      jaq
      xwayland-satellite
    ];
  };
}
