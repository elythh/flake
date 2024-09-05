{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.opt.services.hyprpaper;
in
{
  options.opt.services.hyprpaper.enable = mkEnableOption "hypridle";

  config = mkIf cfg.enable {
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${config.wallpaper}
      wallpaper = , ${config.wallpaper}
    '';

    systemd.user.services.hyprpaper = {
      Unit = {
        Description = "Hyprland wallpaper daemon";
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${lib.getExe inputs.hyprpaper.packages.${pkgs.system}.default}";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
