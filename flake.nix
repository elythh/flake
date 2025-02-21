{
  description = "Configurations of Elyth";

  outputs =
    inputs@{
      home-manager,
      nixpkgs,
      ...
    }:
    {
      # nixos config
      nixosConfigurations = {
        grovetender = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            (import ./system/grovetender "gwen")
            home-manager.nixosModules.home-manager
            { networking.hostName = "grovetender"; }
          ];
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:elythh/nixvim/new";
    };

    morewaita = {
      url = "github:somepaulo/MoreWaita";
      flake = false;
    };

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

  };
}
