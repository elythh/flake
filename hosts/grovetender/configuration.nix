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
    desktop
    docker
    fonts
    hardware
    librewolf
    stylix
    system
  ];

  home-manager.sharedModules =
    attrValues nix-config.homeModules
    ++ singleton {
      programs.btop.enable = true;
    };

  environment.systemPackages = attrValues nix-config.packages.${pkgs.system};

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
  modules.hardware = {
    bluetooth = true;
    keyboardBinds = true;
  };

}
