{
  description = "Elyth's personal dotfile";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/release-23.11";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    nixpkgs-howdy.url = "github:fufexan/nixpkgs/howdy";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-colors.url = "github:misterio77/nix-colors";

    lf-icons.url = "https://raw.githubusercontent.com/gokcehan/lf/master/etc/icons.example";
    lf-icons.flake = false;

    # Zellij plugin for statusbar
    zjstatus.url = "github:dj95/zjstatus";

    flake-parts.url = "github:hercules-ci/flake-parts";

    hm .url = "github:nix-community/home-manager";

    anyrun.url = "github:Kirottu/anyrun";
    ags.url = "github:ozwaldorf/ags";
    nur.url = "github:nix-community/NUR";
    swayfx.url = "github:/WillPower3309/swayfx";
    swayfx.inputs.nixpkgs.follows = "nixpkgs";
    sss.url = "github:/SergioRibera/sss";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    matugen.url = "github:/InioX/Matugen";

    nixvim.url = "github:elythh/nixvim";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nixos-hardware, ... } @inputs:
    let
      inherit (self) outputs;
      forSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      pkgsStable = import nixpkgs-stable {
        inherit system;
      };
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME replace with your hostname
        thinkpad = nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            home-manager.nixosModule
            #nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
            # > Our main nixos configuration file <
            ./hosts/thinkpad/configuration.nix
          ];
        };
      };
      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        # FIXME replace with your username@hostname
        "gwen@thinkpad" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs pkgsStable outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./home/gwen/home.nix
          ];
        };
      };
    };
}



