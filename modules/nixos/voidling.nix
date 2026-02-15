{ inputs, ... }:
{

  flake.nixosConfigurations.voidling = inputs.nixpkgs.lib.nixosSystem {

  };

}
