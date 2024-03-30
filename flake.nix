{
  description = "Elyth's personal dotfile";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-23.11";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    nix-colors.url = "github:misterio77/nix-colors";

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
    hyprpicker.url = "github:hyprwm/hyprpicker";
    split-monitor-workspaces.url = "github:elythh/split-monitor-workspaces";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    nixvim.url = "github:elythh/nixvim";

    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    hm,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgsStable = import nixpkgs-stable {inherit system;};
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        modules = [
          hm.nixosModule
          nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
          # > Our main nixos configuration file <
          ./hosts/thinkpad/configuration.nix
        ];
      };
      hp = nixpkgs.lib.nixosSystem {
        modules = [
          hm.nixosModule
          ./hosts/hp/configuration.nix
        ];
      };
    };
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "gwen@thinkpad" = inputs.hm.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs pkgsStable outputs;};
        modules = [
          # > Our main home-manager configuration file <
          ./home/gwen/thinkpad.nix
        ];
      };
      "gwen@hp" = inputs.hm.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs pkgsStable outputs;};
        modules = [
          # > Our main home-manager configuration file <
          ./home/gwen/hp.nix
        ];
      };
    };
  };
}
