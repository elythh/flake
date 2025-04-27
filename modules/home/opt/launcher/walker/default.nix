{
  inputs,
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.meadow.opt.launcher.walker;
in
{
  options.meadow.opt.launcher.walker.enable = mkEnableOption "Walker";

  imports = [ inputs.walker.homeManagerModules.default ];

  config.programs.walker = mkIf cfg.enable {
    enable = true;
    runAsService = true;

    config = {
      activation_mode.disabled = true;
      ignore_mouse = true;
    };

    theme = {
      layout = {
        ui.window.box = {
          v_align = "center";
          orientation = "vertical";
        };
      };

      style = ''
        child {
          border-radius: 0;
        }
      '';
    };
  };
}
