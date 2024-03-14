{
  description = "Elyth's personal dotfile";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-23.11";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    nix-colors.url = "github:misterio77/nix-colors";

    lf-icons.url = "https://raw.githubusercontent.com/gokcehan/lf/master/etc/icons.example";
    lf-icons.flake = false;

    # Zellij plugin for statusbar
    zjstatus.url = "github:dj95/zjstatus";

    flake-parts.url = "github:hercules-ci/flake-parts";

    hm.url = "github:nix-community/home-manager";

    anyrun.url = "github:Kirottu/anyrun";
    ags.url = "github:ozwaldorf/ags";
    nur.url = "github:nix-community/NUR";
    # swayfx.url = "github:/WillPower3309/swayfx";
    # swayfx.inputs.nixpkgs.follows = "nixpkgs";
    sss.url = "github:/SergioRibera/sss";
    sss.inputs.nixpkgs.follows = "nixpkgs";
    waybar.url = "github:/alexays/waybar";

    hyprland.url = "github:hyprwm/hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";
    hypridle.url = "github:hyprwm/hypridle";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    split-monitor-workspaces.url = "github:elythh/split-monitor-workspaces";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    nixvim.url = "github:elythh/nixvim";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgsStable = import nixpkgs-stable {inherit system;};
  in {
    overlays = import ./nix/overlays {inherit inputs;};

    pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
      src = ./.;
      hooks = {
        statix.enable = true;
        alejandra.enable = true;
      };
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          home-manager.nixosModule
          nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
          # > Our main nixos configuration file <
          ./hosts/thinkpad/configuration.nix
        ];
      };
      hp = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [home-manager.nixosModule ./hosts/hp/configuration.nix];
      };
    };
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "gwen@thinkpad" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs pkgsStable outputs;};
        modules = [
          # > Our main home-manager configuration file <
          ./home/gwen/home.nix
        ];
      };
      "gwen@hp" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs =
          nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs pkgsStable outputs;};
        modules = [
          # > Our main home-manager configuration file <
          ./home/gwen/work.nix
        ];
      };
    };
  };
}
