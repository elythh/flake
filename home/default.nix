{ self, inputs, ... }:
{
  flake =
    let

      inherit (inputs.hm.lib) homeManagerConfiguration;

      extraSpecialArgs = {
        inherit inputs self;
      };
    in
    {
      homeConfigurations = {
        "gwen@grovetender" = homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          inherit extraSpecialArgs;
          modules = [ ./gwen/grovetender.nix ];
        };
        "gwen@aurelionite" = homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          inherit extraSpecialArgs;
          modules = [ ./gwen/aurelionite.nix ];
        };
      };
    };
}
