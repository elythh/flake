{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.meadow.services.hyprpaper;
in {
  options.meadow.services.hyprpaper.enable = mkEnableOption "hypridle";

  config = mkIf cfg.enable {
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${config.meadow.style.wallpaper}
      wallpaper = , ${config.meadow.style.wallpaper}
    '';

    systemd.user.services.hyprpaper = {
      Unit = {
        Description = "Hyprland wallpaper daemon";
        PartOf = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.hyprpaper}";
        Restart = "on-failure";
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
