{
  nix-config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) singleton;
  inherit (builtins) attrValues;
in
{
  imports = with nix-config.nixosModules; [
    system
  ];

  home-manager.sharedModules =
    attrValues nix-config.homeModules
    ++ singleton {
      programs.btop.enable = true;
    };

  environment.systemPackages = with pkgs; [
    ruby
    php
  ];

  modules.system = {
    username = "gwen";
    hostName = "grovetender";
    timeZone = "Europe/Paris";
    defaultLocale = "fr_FR.UTF-8";
    stateVersion = "24.11";
  };
  modules.desktop = {
    bloat = true;
  };

}
