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
        hostname:
        homeManagerConfiguration {
          inherit extraSpecialArgs pkgs;
          modules = [ ./gwen/${hostname}.nix ];
        };
    in
    {
      "gwen@grovetender" = mkHome "grovetender";
      "gwen@aurelionite" = mkHome "aurelionite";
    };
}
