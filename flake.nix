{
  description = "Elyth's personal dotfile";

  outputs =
    {
      self,
      nixpkgs,
      hm,
      nix-darwin,
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
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs lib;
              };
              home-manager.users.gwen.imports = [ userConfigs ];
            }
          ];
        };

      mkDarwinSystem =
        {
          userConfigs,
          system ? "aarch64-darwin",
          lib ? mkLib packages.${system},
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs outputs lib;
          };
          modules = [
            { nixpkgs.hostPlatform = system; }
            hm.darwinModules.home-manager
            {
              # home-manager.sharedModules = [
              #   ./modules/home
              # ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs lib;
              };
              home-manager.users.elyth.home.homeDirectory = lib.mkForce "/Users/elyth";
              home-manager.users.elyth.home.stateVersion = "25.11";
              system.stateVersion = 5;
              nix.enable = false;
            }
          ];
        };

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
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
      darwinConfigurations = { # <-- New section for Darwin systems
        "Gwenchlans-MacBook-Pro"  = mkDarwinSystem {
          userConfigs = ./home/profiles/voidling.nix;
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            deadnix = {
              enable = true;
              settings.noLambdaArg = true;
            };
            nixfmt-rfc-style.enable = true;
          };
        };
      });

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };
      });
    };

  inputs = {
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    impermanence.url = "github:nix-community/impermanence";

    # Nixpkgs Stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home-manager
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    # secret management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Stylix, nix-colors alertnative
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # Spicetify, a spotify theming tool
    spicetify.url = "github:Gerg-L/spicetify-nix";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";

    # My personal nixvim config
    neovim.url = "github:elythh/nvim";
    neovim.inputs.nixpkgs.follows = "nixpkgs";

    # DELETEME: Zen
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # Nixcord
    nixcord.url = "github:kaylorben/nixcord";

    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";

    caelestia-cli.url = "github:caelestia-dots/cli";

    caelestia.url = "github:caelestia-dots/shell";
    caelestia.inputs.quickshell.follows = "quickshell";

    astal-shell.url = "github:knoopx/astal-shell";
    astal-shell.inputs.nixpkgs.follows = "nixpkgs";

    vicinae.url = "github:vicinaehq/vicinae";
  };
  nixConfig = {
    trusted-substituters = [
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
    ];
    trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
}
