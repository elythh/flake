{
  description = "Elyth's personal dotfile";

  inputs = {
    nix-colors.url = "github:misterio77/nix-colors";

    lf-icons = {
      url = "https://raw.githubusercontent.com/gokcehan/lf/master/etc/icons.example";
      flake = false;
    };

    # Zellij plugin for statusbar
    zjstatus.url = "github:dj95/zjstatus";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    nixpkgs-howdy.url = "github:fufexan/nixpkgs/howdy";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nix-colors, spicetify-nix, nixpkgs-f2k, ... } @inputs:
    let
      inherit (self) outputs;
      forSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME replace with your hostname
        thinkpad = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            home-manager.nixosModule
            nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
            # > Our main nixos configuration file <
            ./hosts/thinkpad/configuration.nix
          ];
        };
      };
      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        # FIXME replace with your username@hostname
        "gwen@thinkpad" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs nix-colors outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./home/gwen/home.nix
          ];
        };
      };
    };
}

