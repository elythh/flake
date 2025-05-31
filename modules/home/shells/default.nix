{ lib, ... }:
with lib;
{
  imports = lib.meadow.readSubdirs ./.;
  options.meadow.default.shell = mkOption {
    type = types.listOf (
      types.enum [
        "zsh"
        "fish"
        "nushell"
      ]
    );
    default = [ "fish" ];
  };
}
