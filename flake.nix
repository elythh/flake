{
  description = "Elyth's personal dotfile";

  inputs = {
    # Nixpkgs Stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # grub2 theme
    grub2-themes.url = "github:vinceliuice/grub2-themes";
    grub2-themes.inputs.nixpkgs.follows = "nixpkgs";

    # Home-manager
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    # nix helper
    nh.url = "github:viperML/nh";
    nh.inputs.nixpkgs.follows = "nixpkgs";

    # Nixos hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Stylix, nix-colors alertnative
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # Zellij plugin for statusbar
    zjstatus.url = "github:dj95/zjstatus";
    zjstatus.inputs.nixpkgs.follows = "nixpkgs";

    # Anyrun, an app launcher
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    # Ags, a customizable and extensible shell
    ags.url = "github:Aylur/ags";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # SuperScreenShot
    sss.url = "github:SergioRibera/sss";
    sss.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland, the modern compositor for wayland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprspacem workspace overview plugin
    hyprspace.url = "github:KZDKM/Hyprspace";
    hyprspace.inputs.hyprland.follows = "hyprland";

    # Hyprpaper, wallpaper manager for hyprland
    hyprpaper.url = "github:hyprwm/hyprpaper";

    # hyprpicker, color picker for hyprland
    hyprpicker.url = "github:hyprwm/hyprpicker";

    # Spicetify, a spotify theming tool
    spicetify.url = "github:Gerg-L/spicetify-nix";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";

    # My personal nixvim config
    nixvim.url = "github:elythh/nixvim";
  };

  outputs = inputs: {
    nixosConfigurations = {
      grovetender = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.hm.nixosModule
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
          inputs.grub2-themes.nixosModules.default

          ./hosts/grovetender/configuration.nix
        ];
      };
      aurelionite = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.hm.nixosModule
          inputs.grub2-themes.nixosModules.default

          ./hosts/aurelionite/configuration.nix
        ];
      };
      mithrix = inputs.nixpkgs.lib.nixosSystem { modules = [ ./hosts/mithrix/configuration.nix ]; };
    };
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "gwen@grovetender" = inputs.hm.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          # > Our main home-manager configuration file <
          ./home/gwen/grovetender.nix
          inputs.stylix.homeManagerModules.stylix
        ];
      };
      "gwen@aurelionite" = inputs.hm.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          # > Our main home-manager configuration file <
          ./home/gwen/aurelionite.nix
          inputs.stylix.homeManagerModules.stylix
        ];
      };
    };
  };
}
