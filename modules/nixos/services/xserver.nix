{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.opt.services.xserver;
in
{
  options.opt.services.xserver.enable = mkEnableOption "xserver";
  config = mkIf cfg.enable {
    services = {
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          middleEmulation = true;
          naturalScrolling = true;
        };
      };
      xserver = {
        enable = true;
        videoDrivers = [ "amdgpu" ];
        desktopManager.gnome.enable = false;
      };
      displayManager = {
        defaultSession = "none+hyprland";
      };
    };
  };
}
