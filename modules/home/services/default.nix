{ lib, ... }:
{
  imports = lib.meadow.readSubdirs ./.;
}
