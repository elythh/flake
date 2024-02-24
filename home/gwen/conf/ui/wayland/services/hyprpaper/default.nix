{ lib, inputs, pkgs, config, ... }: {
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
      ExecStart =
        "${lib.getExe inputs.hyprpaper.packages.${pkgs.system}.default}";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
