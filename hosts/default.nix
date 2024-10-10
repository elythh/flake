{ self, inputs, ... }:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      inherit (import "${self}/modules/nixos") default;

      specialArgs = {
        inherit inputs self;
      };

      mkHost =
        hostname:
        nixosSystem {
          inherit specialArgs;
          modules = default ++ [ ./${hostname} ];
        };
    in
    {
      grovetender = mkHost "grovetender";
      aurelionite = mkHost "aurelionite";
      mithrix = mkHost "mithrix";
    };
}
