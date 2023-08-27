{ config, lib, pkgs, hyprland, hyprland-plugins, colors, ... }:

{
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = with colors; {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemdIntegration = true;
        extraConfig = ''
        source = ~/.config/hypr/settings.conf
        source = ~/.config/hypr/rules.conf
        source = ~/.config/hypr/binds.conf
        source = ~/.config/hypr/theme.conf
        source = ~/.config/hypr/autostart.conf
        '';
  };
}
