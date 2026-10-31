{ config, lib, ... }:
{
  # Session, portals (wlr + gtk) come from inputs.mango.nixosModules.mango, imported per host
  programs.mango.enable = lib.mkIf (lib.elem "mango" config.meadow.wms) true;
}
