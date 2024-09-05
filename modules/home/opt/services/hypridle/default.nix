{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.opt.services.hypridle;
in
{
  options.opt.services.hypridle.enable = mkEnableOption "hyprdidle";

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
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
            on-timeout = "hyprlock";
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
