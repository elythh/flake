{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe';
in
{
  "$schema" = "/etc/xdg/swaync/configSchema.json";
  control-center-height = 600;
  control-center-margin-bottom = 0;
  control-center-margin-left = 0;
  control-center-margin-right = 10;
  control-center-margin-top = 10;
  control-center-width = 500;
  cssPriority = "user";
  fit-to-screen = true;
  hide-on-action = true;
  hide-on-clear = false;
  image-visibility = "when-available";
  keyboard-shortcuts = true;
  layer = "top";
  notification-body-image-height = 100;
  notification-body-image-width = 200;
  notification-icon-size = 64;
  notification-visibility = { };
  notification-window-width = 500;
  positionX = "right";
  positionY = "top";
  script-fail-notify = true;
  scripts = { };
  timeout = 10;
  timeout-critical = 0;
  timeout-low = 5;
  transition-time = 200;

  widgets = [
    "label"
    "menubar"
    "buttons-grid"
    "volume"
    "mpris"
    "title"
    "dnd"
    "notifications"
  ];

  widget-config = {
    title = {
      text = "Notifications";
      clear-all-button = true;
      button-text = "Clear All";
    };
    dnd = {
      text = "Do Not Disturb";
    };
    label = {
      max-lines = 1;
      text = "Control Center";
    };
    mpris = {
      image-size = 96;
      image-radius = 12;
    };
    volume = {
      label = "";
      show-per-app = true;
    };
    "menubar" = {
      "menu#power-buttons" = {
        label = "";
        position = "right";
        actions = [
          {
            label = " Reboot";
            command = "systemctl reboot";
          }
          {
            label = " Lock";
            command = "hyprlock --immediate";
          }
          {
            label = " Logout";
            command = "hyprctl exit";
          }
          {
            label = " Shut down";
            command = "systemctl poweroff";
          }
        ];
      };

      "menu#screenshot-buttons" = {
        label = "";
        position = "left";
        actions = [
          {
            label = "󰍹";
            command = "${getExe' pkgs.grimblast "grimblast --notify copy screen"}";
          }
          {
            label = "";
            command = "${getExe' pkgs.grimblast "grimblast --notify --freeze copy area"}";
          }
          {
            label = "";
            command = "${getExe' pkgs.grimblast "grimblast --notify --freeze copy area"}";
          }
        ];
      };
    };

    buttons-grid = {
      actions = [
        {
          label = "";
          command = "${getExe' pkgs.networkmanagerapplet "nm-connection-editor"}";
        }
        {
          label = "";
          command = "${getExe' pkgs.blueman "blueman-manager"}";
        }
      ];
    };
  };
}
