{
  self,
  lib,
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      inherit (import "${self}/modules/nixos") default;

      homeImports = import "${self}/home";

      specialArgs = {
        inherit inputs self;
      };

      mkHost =
        {
          hostname,
          user ? null,
        }:
        nixosSystem {
          inherit specialArgs;
          modules = default ++ [
            ./${hostname}
            (lib.mkIf (user != null) {
              home-manager = {
                users.${user}.imports = homeImports.${hostname};
                extraSpecialArgs = specialArgs;
              };
            })
          ];
        };
    in
    {
      grovetender = mkHost {
        hostname = "grovetender";
        user = "gwen";
      };
      aurelionite = mkHost {
        hostname = "aurelionite";
        user = "gwen";
      };
      mithrix = mkHost {
        hostname = "mithrix";
      };
    };
}
