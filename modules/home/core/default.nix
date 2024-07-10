{ inputs
, config
, ...
}: {
  wallpaper = /etc/nixos/home/shared/walls/magma.png;
  home.sessionVariables.EDITOR = "nvim";
  imports = [
    ./gtk.nix
    ./nixpkgs.nix
    ./options.nix
    ./overlays.nix
    ./programs.nix
    ./style/stylix.nix
    ./home.nix
    inputs.nix-colors.homeManagerModules.default
  ];

  programs.home-manager.enable = true;
}
