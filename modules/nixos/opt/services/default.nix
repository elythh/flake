{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./cloudflared-tunnel.nix
    ./glance.nix
    ./immich.nix
    ./kanata.nix
    ./paperless.nix
    ./radicle.nix
    ./soft-serve.nix
    ./vikunja.nix
    ./xserver.nix
    ./your_spotify.nix
  ];
  config = {
    services = {
      blueman.enable = true;
      dbus.enable = true;
      upower.enable = true;
      logind = {
        powerKey = "suspend";
        lidSwitch = "suspend";
        lidSwitchExternalPower = "lock";
      };

      tailscale = lib.mkIf config.tailscale.enable { enable = true; };

      xserver.enable = true;

      xserver.xkb = {
        layout = "us";
      };

      xserver.xkb.options = "compose:rctrl,caps:escape";

      pipewire = lib.mkIf config.pipewire.enable {
        enable = true;
        pulse.enable = true;
      };

      gnome = {
        gnome-keyring.enable = true;
        glib-networking.enable = true;
      };

      greetd = lib.mkIf config.wayland.enable {
        enable = true;
        settings = {
          terminal.vt = 1;
          default_session = {
            command = lib.concatStringsSep " " [
              (lib.getExe pkgs.greetd.tuigreet)
              "--time"
              "--remember"
              "--remember-user-session"
              "--asterisks"
              "--sessions 'Hyprland'"
              "--cmd 'Hyprland'"
            ];
            user = "greeter";
          };
        };
      };
    };
  };
}
