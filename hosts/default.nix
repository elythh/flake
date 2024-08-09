{ self, inputs, ... }:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      inherit (import "${self}/modules/nixos") default;

      specialArgs = {
        inherit inputs self;
      };
    in
    {
      grovetender = nixosSystem {
        inherit specialArgs;
        modules = default ++ [
          inputs.hm.nixosModule
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
          inputs.grub2-themes.nixosModules.default

          ./grovetender
        ];
      };
      aurelionite = nixosSystem {
        inherit specialArgs;
        modules = default ++ [
          inputs.hm.nixosModule
          inputs.grub2-themes.nixosModules.default

          ./aurelionite
        ];
      };
      mithrix = nixosSystem { modules = [ ./mithrix ]; };
    };
}
