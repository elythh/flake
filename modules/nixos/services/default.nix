{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
in
{
  options.meadow.services = {
    pipewire.enable = mkEnableOption "pipewire";
  };
  config = {
    services = {
      gvfs.enable = true;
      blueman.enable = true;
      dbus.enable = true;
      upower.enable = true;
      logind = {
        powerKey = "suspend";
        lidSwitch = "suspend";
        lidSwitchExternalPower = "lock";
      };

      tailscale = mkIf config.meadow.programs.tailscale.enable { enable = true; };

      # xserver.enable = true;

      xserver.xkb = {
        layout = "us";
      };

      xserver.xkb.options = "compose:rctrl,caps:escape";

      pipewire = mkIf config.meadow.services.pipewire.enable {
        enable = true;
        pulse.enable = true;
      };

      gnome = {
        gnome-keyring.enable = true;
        glib-networking.enable = true;
      };

      # greetd = mkIf config.meadow.programs.wayland.enable {
      #   enable = true;
      #   settings = {
      #     terminal.vt = 1;
      #     default_session = {
      #       command = concatStringsSep " " [
      #         (getExe pkgs.greetd.tuigreet)
      #         "--time"
      #         "--remember"
      #         "--remember-user-session"
      #         "--asterisks"
      #         "--sessions 'hyprland'"
      #         "--cmd 'hyprland'"
      #       ];
      #       user = "greeter";
      #     };
      #   };
      # };
    };
  };
}
