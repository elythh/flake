{
  pkgs,
  lib,
  config,
  ...
}: let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
    if [ $? == 1 ]; then
      waylock && ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
in {
  config = lib.mkIf (config.default.lock == "swaylock" && config.default.de == "hyprland") {
    services.swayidle = {
      enable = true;
      systemdTarget = "graphical-session.target";
      events = [
        {
          event = "lock";
          command = "${pkgs.swaylock-effects}/bin/swaylock -i ${config.wallpaper} --daemonize --grace 15";
        }
      ];
      timeouts = [
        {
          timeout = 600;
          command = suspendScript.outPath;
        }
      ];
    };

    systemd.user.services.swayidle.Install.WantedBy =
      lib.mkForce ["hyprland-session.target"];
  };
}
