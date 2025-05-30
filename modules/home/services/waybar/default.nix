{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.meadow.services.waybar;
in
{
  options.meadow.services.waybar.enable = mkEnableOption "waybar";

  config.programs.waybar = with config.lib.stylix.colors.withHashtag; {
    enable = mkIf cfg.enable true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    settings = [
      {
        layer = "top";
        position = "top";
        exclusive = true;
        passthrough = false;
        fixed-center = true;
        gtk-layer-shell = true;
        spacing = 0;
        name = "hobar";
        modules-left = [
          "image"
          "clock"
          "hyprland/workspaces"
          "tray"
        ];
        modules-right = [
          "battery"
          "memory"
          "pulseaudio"
          "clock"
        ];

        "image" = {
          path = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          size = 24;
          tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "{id}";
          active-only = false;
          format-icons = {
            "1" = "Q";
            "2" = "W";
            "3" = "E";
            "4" = "R";
            "5" = "T";
            "6" = "Y";
            "7" = "U";
            "8" = "I";
            "9" = "O";
            "10" = "P";
          };
        };

        "group/backlight-modules" = {
          modules = [
            "backlight#icon"
            "backlight#percent"
          ];
          orientation = "inherit";
        };

        "backlight#icon" = {
          format = "{icon}";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+ &> /dev/null";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 1%- &> /dev/null";
          tooltip-format = "Backlight: {percent}%";
        };

        "backlight#percent" = {
          format = "{percent}%";
          tooltip-format = "Backlight: {percent}%";
        };

        tray = {
          icon-size = 14;
          spacing = 14;
          show-passive-items = true;
          reverse-direction = true;
        };

        memory = {
          interval = 20;
          format = "MEM: [ {icon} ] <span size='8pt'>{percentage}%</span>";
          tooltip-format = "MEM_TOT\t: {total}GiB\nSWP_TOT\t: {swapTotal}GiB\n\nMEM_USD\t: {used:0.1f}GiB\nSWP_USD\t: {swapUsed:0.1f}GiB";
          format-icons = [
            "░░░░░░░░"
            "█░░░░░░░"
            "██░░░░░░"
            "███░░░░░"
            "████░░░░"
            "█████░░░"
            "██████░░"
            "<span color='#B7416E'>!!!!!!!!</span>"
            "<span color='#B7416E'>CRITICAL</span>"
          ];
        };

        battery = {
          states = {
            warning = 20;
            critical = 15;
          };
          format = "BAT= [ {icon} ] <span size='8pt'>{capacity}%</span>";
          interval = 5;
          format-charging = "BAT= [ {icon} ] <span size='8pt'>CHRG</span>";
          format-plugged = "BAT= [ {icon} ] <span size='8pt'>PLUG</span>";
          tooltip-format = "BATTERY= {power}W\nSTATUS= {timeTo}\nCYCLES= {cycles}\nHEALTH= {health}";
          format-icons = [
            "<span color='#B7416E'>CRITICAL"
            "<span color='#B7416E'>!!!!!!!!</span>"
            "██░░░░░░"
            "███░░░░░"
            "████░░░░"
            "█████░░░"
            "██████░░"
            "███████░"
            "████████"
          ];
        };

        clock = {
          actions = {
            on-scroll-down = "shift_down";
            on-scroll-up = "shift_up";
          };
          calendar = {
            format = {
              days = "<span color='${base04}'><b>{}</b></span>";
              months = "<span color='${base05}'><b>{}</b></span>";
              today = "<span color='${base05}'><b><u>{}</u></b></span>";
              weekdays = "<span color='${base0D}'><b>{}</b></span>";
            };
            mode = "month";
            on-scroll = 1;
          };
          format = "{:%I:%M %p}";
          tooltip-format = "{calendar}";
        };
      }
    ];

    style = ''
      * {
          border: none;
          font-family: Roboto, RobotoMono Nerd Font;
          font-weight: bold;
          font-size: 14px;
          min-height: 0;
          padding: 2px;
          border-radius: 0px;
      }

      window#waybar {
          background: @theme_bg_color;
          color: @theme_fg_color;
      }

      tooltip {
          background: @theme_bg_color;
      }

      #workspaces button {
          color: @theme_fg_color;
      }

      #workspaces button.active {
          color: @theme_selected_bg_color;
          background: @theme_bg_color;
      }

      #workspaces button.focused {
          color: @theme_fg_color;
          background: @theme_bg_color;
      }

      #workspaces button.urgent {
          color: @theme_fg_color;
          background: @theme_bg_color;
      }

      #workspaces button:hover {
          background: @theme_fg_color;
          color: @theme_bg_color;
      }

      #custom-language,
      #custom-updates,
      #custom-caffeine,
      #custom-weather,
      #window,
      #clock,
      #battery,
      #pulseaudio,
      #network,
      #workspaces,
      #tray,
      #cpu,
      #backlight {
          background: @theme_base_color;
          padding: 0px 10px;
          margin: 0px;
      }

      #tray {
          margin-right: 10px;
      }

      #workspaces {
          color: @theme_text_color;
      }

      #window {
          color: @theme_text_color;
      }

      #clock {
          color: @theme_text_color;
      }

      #network {
          color: @theme_text_color;
      }

      #pulseaudio {
          color: @theme_text_color;
      }

      #pulseaudio.microphone {
          color: @theme_text_color;
      }

      #battery {
          color: @theme_text_color;
      }

      #battery.warning:not(.charging) {
      	color: #C4E969;
      }

      #battery.critical:not(.charging) {
      	color: #B7416E;
      }

      #custom-weather {
          color: @theme_text_color;
      }
    '';
  };
}
