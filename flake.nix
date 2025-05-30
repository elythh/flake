{
  description = "Elyth's personal dotfile";

  inputs = {
    impermanence.url = "github:nix-community/impermanence";

    # Nixpkgs Stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # grub2 theme
    grub2-themes.url = "github:vinceliuice/grub2-themes";
    grub2-themes.inputs.nixpkgs.follows = "nixpkgs";

    # Home-manager
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    # secret management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Stylix, nix-colors alertnative
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # Ags, a customizable and extensible shell
    ags.url = "github:Aylur/ags";
    ags.inputs.nixpkgs.follows = "nixpkgs";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # Spicetify, a spotify theming tool
    spicetify.url = "github:Gerg-L/spicetify-nix";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";

    # My personal nixvim config
    neovim.url = "github:elythh/nvim-nix";

    # DELETEME: Zen
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    firefox-gnome-theme.url = "github:rafaelmardojai/firefox-gnome-theme";
    firefox-gnome-theme.flake = false;

    # Nixcord
    nixcord.url = "github:kaylorben/nixcord";

    # Niri
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    # fabric
    fabric.url = "github:Fabric-Development/fabric";
    fabric.inputs.nixpkgs.follows = "nixpkgs";

    fabric-cli.url = "github:HeyImKyu/fabric-cli";
    fabric-cli.inputs.nixpkgs.follows = "nixpkgs";

    fabric-gray.url = "github:Fabric-Development/gray";
    fabric-gray.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      hm,
      ...
    }@inputs:
    let
      outputs = self;
      mkLib = pkgs: pkgs.lib.extend (final: prev: (import ./lib final pkgs) // hm.lib);
      packages = nixpkgs.legacyPackages;

      mkSystem =
        {
          system ? "x86_64-linux",
          systemConfig,
          userConfigs,
          lib ? mkLib packages.${system},
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs lib;
          };
          modules = [
            { nixpkgs.hostPlatform = system; }
            systemConfig
            hm.nixosModules.home-manager
            ./modules/nixos
            {
              home-manager.sharedModules = [
                ./modules/home
              ];
              # home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs outputs lib; };
              home-manager.users.gwen.imports = [ userConfigs ];
            }
          ];
        };

    in
    {
      nixosConfigurations = {
        grovetender = mkSystem {
          systemConfig = ./hosts/grovetender;
          userConfigs = ./home/profiles/grovetender.nix;
        };
        aurelionite = mkSystem {
          systemConfig = ./hosts/aurelionite;
          userConfigs = ./home/profiles/aurelionite.nix;
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
