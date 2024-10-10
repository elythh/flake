{ self, inputs, ... }:
{
  flake.homeConfigurations =
    let
      inherit (inputs.hm.lib) homeManagerConfiguration;

      extraSpecialArgs = {
        inherit inputs self;
      };
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

      mkHome =
        user: hostname:
        homeManagerConfiguration {
          inherit extraSpecialArgs pkgs;
          modules = [ ./${user}/${hostname}.nix ];
        };
    in
    {
      "gwen@grovetender" = mkHome "gwen" "grovetender";
      "gwen@aurelionite" = mkHome "gwen" "aurelionite";
    };
}
