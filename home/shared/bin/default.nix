{ config, colors, ... }:

{
  home = {
    file = {
      ".local/bin/fetch" = {
        executable = true;
        text = import ./eyecandy/nixfetch.nix { };
      };
      ".local/bin/lut" = {
        executable = true;
        text = import ./misc/lut.nix { inherit colors; };
      };
      ".local/bin/lcon" = {
        executable = true;
        text = import ./misc/con.nix { };
      };
      ".local/bin/roundvalue" = {
        executable = true;
        text = import ./misc/roudnvalue.nix { };
      };
      ".local/bin/setTheme" = {
        executable = true;
        text = import ./misc/changeTheme.nix { };
      };
      ".local/bin/setWall" = {
        executable = true;
        text = import ./misc/changeWall.nix { };
      };
      ".local/bin/tiling" = {
        executable = true;
        text = import ./misc/tiling.nix { };
      };
      ".local/bin/panes" = {
        executable = true;
        text = import ./eyecandy/panes.nix { };
      };
      ".local/bin/wifimenu" = {
        executable = true;
        text = import ./rofiscripts/wifi.nix { };
      };
      ".local/bin/powermenu" = {
        executable = true;
        text = import ./rofiscripts/powermenu.nix { };
      };
      ".local/bin/changebrightness" = {
        executable = true;
        text = import ./notifs/changebrightness.nix { };
      };
      ".local/bin/volume" = {
        executable = true;
        text = import ./notifs/changevolume.nix { };
      };
      ".local/bin/captureAll" = {
        executable = true;
        text = import ./screenshot/captureAll.nix { };
      };
      ".local/bin/captureArea" = {
        executable = true;
        text = import ./screenshot/captureArea.nix { };
      };
      ".local/bin/captureScreen" = {
        executable = true;
        text = import ./screenshot/captureScreen.nix { };
      };
      ".local/bin/wscreenshot" = {
        executable = true;
        text = import ./rofiscripts/wlscr.nix { };
      };
      ".local/bin/genmenupic" = {
        executable = true;
        text = import ./misc/genmenupic.nix { inherit colors; };
      };
      ".local/bin/gencontrolpic" = {
        executable = true;
        text = import ./misc/genpicforcontrol.nix { inherit colors; };
      };
      ".local/bin/lock" = {
        executable = true;
        text = import ./hyprland-utils/lock.nix { };
      };
      ".local/bin/wofi-emoji" = {
        executable = true;
        text = import ./hyprland-utils/wofi-emoji.nix { };
      };
      ".local/bin/record-script" = {
        executable = true;
        text = import ./hyprland-utils/record-script.nix { };
      };
      ".local/bin/wallpicker" = {
        executable = true;
        text = import ./hyprland-utils/wallpicker.nix { };
      };
      ".local/bin/themepicker" = {
        executable = true;
        text = import ./hyprland-utils/themepicker.nix { };
      };
    };
  };
}
