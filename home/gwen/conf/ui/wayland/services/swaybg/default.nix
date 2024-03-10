{
  lib,
  pkgs,
  config,
  ...
}: {
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${
        lib.getExe pkgs.swaybg
      } --mode fill --image /etc/nixos/home/shared/walls/default.jpg";
      Restart = "on-failure";
    };

    Install.WantedBy = ["graphical-session.target"];
  };
}
