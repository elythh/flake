{ config, ... }:
{
  wallpaper = /etc/nixos/home/shared/walls/${config.theme}.jpg;
  home.sessionVariables.EDITOR = "nvim";
  imports = [
    ./gtk.nix
    ./nixpkgs.nix
    ./options.nix
    ./overlays.nix
    ./programs.nix
    ./style/stylix.nix
    ./home.nix
  ];

  programs.home-manager.enable = true;
}
