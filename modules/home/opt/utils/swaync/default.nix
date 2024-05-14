{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.swaync;
in {
  meta.maintainers = [lib.maintainers.rhoriguchi];

  config = lib.mkIf (config.default.bar == "waybar") {
    # at-spi2-core is to minimize journalctl noise of:
    # "AT-SPI: Error retrieving accessibility bus address: org.freedesktop.DBus.Error.ServiceUnknown: The name org.a11y.Bus was not provided by any .service files"
    home.packages = [cfg.package pkgs.at-spi2-core];

    xdg.configFile = {
      "swaync/style.css" = lib.mkIf (cfg.style != null) {
        source =
          if builtins.isPath cfg.style || lib.isStorePath cfg.style
          then cfg.style
          else pkgs.writeText "swaync/style.css" cfg.style;
      };
    };

    systemd.user.services.swaync = {
      Unit = {
        Description = "Swaync notification daemon";
        Documentation = "https://github.com/ErikReider/SwayNotificationCenter";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session-pre.target"];
        ConditionEnvironment = "WAYLAND_DISPLAY";

        X-Restart-Triggers =
          ["${config.xdg.configFile."swaync/config.json".source}"]
          ++ lib.optional (cfg.style != null)
          "${config.xdg.configFile."swaync/style.css".source}";
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${cfg.package}/bin/swaync";
        ExecReload =
          ["${cfg.package}/bin/swaync-client --reload-config"]
          ++ lib.optional (cfg.style != null)
          "${cfg.package}/bin/swaync-client --reload-css";
        Restart = "on-failure";
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
