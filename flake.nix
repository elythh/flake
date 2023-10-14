{
  description = "Your new nix config";

  inputs = {
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Hyrpland
    hyprland.url = "github:hyprwm/Hyprland";
    # Hyrpland plugins
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    # Hyprland contrib
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hyrprland split monitor workspaces
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    # Zellij plugin for statusbar
    zjstatus.url = "github:dj95/zjstatus";

    # Fufexan packages
    fufexan-dotfiles = {
      url = "github:fufexan/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gross = {
      url = "github:fufexan/gross";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spicetify
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    # Anyrun
    anyrun.url = "github:Kirottu/anyrun";
    nix-ld.url = "github:Mic92/nix-ld";
    # Channel to follow.
    home-manager.inputs.nixpkgs.follows = "unstable";
    nixpkgs.follows = "unstable";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprland-plugins, anyrun, zjstatus, fufexan-dotfiles, nix-ld, gross, ... } @inputs:
    let
      inherit (self) outputs;
      forSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      overlays = import ./overlays { inherit inputs; };
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME replace with your hostname
        thinkpad = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs home-manager hyprland hyprland-plugins zjstatus fufexan-dotfiles anyrun gross; };
          modules = [
            nix-ld.nixosModules.nix-ld
            home-manager.nixosModule
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
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./home/gwen/home.nix
          ];
        };
      };
    };
}

