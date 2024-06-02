{
  config,
  lib,
  ...
}: {
  home = {
    file = {
      ".local/bin/thisisfine" = {
        executable = true;
        text = import ./misc/thisisfine.nix {};
      };
      ".local/bin/fetch" = {
        executable = true;
        text = import ./eyecandy/nixfetch.nix {};
      };
      ".local/bin/setTheme" = {
        executable = true;
        text = import ./misc/changeTheme.nix {};
      };
      ".local/bin/waylock" = lib.mkIf (config.default.de == "hyprland") {
        executable = true;
        text = ''
          #!/bin/sh
          playerctl pause
          sleep 0.2
          swaylock -i ${config.wallpaper} --effect-blur 10x10
        '';
      };
      ".local/bin/material" = {
        executable = true;
        text = import ./theme/material.nix {};
      };
      ".local/bin/materialpy" = {
        executable = true;
        text = import ./theme/materialpy.nix {};
      };
      ".local/bin/panes" = {
        executable = true;
        text = import ./eyecandy/panes.nix {};
      };
      ".local/bin/powermenu" = {
        executable = true;
        text = import ./rofiscripts/powermenu.nix {};
      };
      ".local/bin/captureCode" = {
        executable = true;
        text = import ./screenshot/captureCode.nix {inherit config;};
      };
      ".local/bin/captureAll" = {
        executable = true;
        text = import ./screenshot/captureAll.nix {};
      };
      ".local/bin/captureArea" = {
        executable = true;
        text = import ./screenshot/captureArea.nix {inherit config;};
      };
      ".local/bin/captureWindow" = {
        executable = true;
        text = import ./screenshot/captureWindow.nix {inherit config;};
      };
      ".local/bin/captureScreen" = {
        executable = true;
        text = import ./screenshot/captureScreen.nix {};
      };
      ".local/bin/screenshot" = {
        executable = true;
        text = import ./rofiscripts/screenshot.nix {};
      };
      ".local/bin/zs" = {
        executable = true;
        text = import ./zellij/zellij-switch.nix {};
      };
      ".local/bin/swayscratch" = {
        executable = true;
        text = import ./misc/swayscratch.nix {};
      };
    };
  };
}
