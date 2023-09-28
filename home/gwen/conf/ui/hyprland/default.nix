{ config, lib, pkgs, hyprland, hyprland-plugins, colors, ... }:

{
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = with colors; {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemdIntegration = true;
    #    plugins = [ hyprland-plugins.packages.${pkgs.system}.hyprbars ];
    extraConfig = ''
      # Set Themes And Configs #
      ## Scripts ##
      exec-once=$HOME/.config/hypr/scripts/autostart
      ## Keybinds and Configs (change to whichever config you want to use) ##
      source=~/.config/hypr/keybinds/default.conf
      source=~/.config/hypr/configs/default.conf
      ## Themes (change to whichever theme you want to use) ##
      source=~/.config/hypr/themes/minimal/theme.conf
      # source=~/.config/hypr/themes/apatheia/theme.conf
    '';
  };
}
