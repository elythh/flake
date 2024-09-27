{ lib, config, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    ;

  cfg = config.opt.services.immich;
in
{
  options.opt.services.immich = {
    enable = mkEnableOption "immich";
    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };
    port = mkOption {
      type = types.int;
      default = 3333;
    };

  };
  config = mkIf cfg.enable {
    services.immich = {
      enable = true;
      inherit (cfg) port host;
    };
  };
}
