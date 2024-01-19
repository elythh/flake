{ config, nix-colors, ... }:

{
  home = {
    file = {
      ".local/bin/fetch" = {
        executable = true;
        text = import ./eyecandy/nixfetch.nix { };
      };
      ".local/bin/setTheme" = {
        executable = true;
        text = import ./misc/changeTheme.nix { };
      };
      ".local/bin/panes" = {
        executable = true;
        text = import ./eyecandy/panes.nix { };
      };
      ".local/bin/powermenu" = {
        executable = true;
        text = import ./rofiscripts/powermenu.nix { };
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
      ".local/bin/screenshot" = {
        executable = true;
        text = import ./rofiscripts/screenshot.nix { };
      };
      ".local/bin/zs" = {
        executable = true;
        text = import ./zellij/zellij-switch.nix { };
      };
      ".local/bin/swayscratch" = {
        executable = true;
        text = import ./misc/swayscratch.nix { };
      };
      "./local/bin/material" = {
        executable = true;
        text = import ./theme/material.nix { };
      };
    };
  };
}
