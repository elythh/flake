{ lib, config, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.meadow.services.kanata;
in
{
  options.meadow.services.kanata = {
    enable = mkEnableOption "kanata";
  };

  config.services.kanata = mkIf cfg.enable {
    enable = true;
    keyboards = {
      internalKeyboard = {
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
           caps
          )
          (defvar
           tap-time 150
           hold-time 200
          )
          (defalias
           caps (tap-hold 100 100 esc lctl)
          )

          (deflayer base
           @caps
          )
        '';
      };
    };
  };
}
