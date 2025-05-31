{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.meadow.services.hypridle;
in
{
  options.meadow.services.hypridle.enable = mkEnableOption "hyprdidle";

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "ags run ~/.config/ags/lockscreen";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 600;
            on-timeout = "ags run ~/.config/ags/lockscreen";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
