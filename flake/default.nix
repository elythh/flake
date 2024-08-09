{ inputs, ... }:
{
  flake = {
    nixosConfigurations = {
      grovetender = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.hm.nixosModule
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
          inputs.grub2-themes.nixosModules.default

          ../hosts/grovetender/configuration.nix
        ];
      };
      aurelionite = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.hm.nixosModule
          inputs.grub2-themes.nixosModules.default

          ../hosts/aurelionite/configuration.nix
        ];
      };

      mithrix = inputs.nixpkgs.lib.nixosSystem { modules = [ ../hosts/mithrix/configuration.nix ]; };
    };
    homeConfigurations = {
      "gwen@grovetender" = inputs.hm.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ../home/gwen/grovetender.nix
          inputs.stylix.homeManagerModules.stylix
        ];
      };
      "gwen@aurelionite" = inputs.hm.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ../home/gwen/aurelionite.nix
          inputs.stylix.homeManagerModules.stylix
        ];
      };
    };
  };
}
