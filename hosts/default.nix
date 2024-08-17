{ self, inputs, ... }:
{
  flake = {
    nixosConfigurations =
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
          modules = default ++ [ ./grovetender ];
        };
        aurelionite = nixosSystem {
          inherit specialArgs;
          modules = default ++ [ ./aurelionite ];
        };
        mithrix = nixosSystem {
          inherit specialArgs;
          modules = [ ./mithrix ];
        };
      };
  };
}
