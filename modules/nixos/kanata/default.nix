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
           a s d f
           j k l ;
          )
          (defvar
           tap-time 200
           hold-time 200
          )
          (defalias
            caps (tap-hold 100 100 esc lctl)
            hm_a (tap-hold $tap-time $hold-time a lmet)
            hm_s (tap-hold $tap-time $hold-time s lalt)
            hm_d (tap-hold $tap-time $hold-time d lctl)
            hm_f (tap-hold $tap-time $hold-time f lsft)
            hm_j (tap-hold $tap-time $hold-time j rsft)
            hm_k (tap-hold $tap-time $hold-time k rctl)
            hm_l (tap-hold $tap-time $hold-time l ralt)
            hm_semicolon (tap-hold $tap-time $hold-time ; rmet)
          )

          (deflayer base
            @caps
            @hm_a @hm_s @hm_d @hm_f
            @hm_j @hm_k @hm_l @hm_semicolon
          )
        '';
      };
    };
  };
}
