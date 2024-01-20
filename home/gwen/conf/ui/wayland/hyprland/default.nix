{ config, inputs, lib, pkgs, ... }:
let
  split-monitor-workspaces = inputs.split-monitor-workspaces;
in
{
  imports = [

    ./programs/swaylock.nix

    ./services/cliphist.nix
    ./services/swaybg.nix
    ./services/swayidle.nix
  ];

  home = {
    packages = with pkgs; [
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      inputs.anyrun.packages.${pkgs.system}.anyrun
      config.wayland.windowManager.hyprland.package

      autotiling-rs
      cliphist
      dbus
      libnotify
      libcanberra-gtk3
      wf-recorder
      brightnessctl
      pamixer
      slurp
      glib
      grim
      gtk3
      hyprpicker
      swappy
      swaysome
      wl-clipboard
      wl-screenrec
      wlr-randr
      wtype
      sassc
      xdg-utils
      ydotool
      wlr-randr
    ];

    sessionVariables = {
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland,x11";
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  wayland.windowManager.hyprland = {
    plugins = [
      split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    systemd = {
      enable = true;
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.cache";
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}