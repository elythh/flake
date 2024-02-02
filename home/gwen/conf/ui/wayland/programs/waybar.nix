{ lib, pkgs, config, ... }:
let
  _ = lib.getExe;
  inherit (pkgs) brightnessctl pamixer;

  snowflake = builtins.fetchurl rec {
    name = "Logo-${sha256}.svg";
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg";
    sha256 = "14mbpw8jv1w2c5wvfvj8clmjw0fi956bq5xf9s2q3my14far0as8";
  };

in
{
  programs.waybar = with config.colorscheme.palette;
    {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "left";
          exclusive = true;
          fixed-center = true;
          gtk-layer-shell = true;
          spacing = 0;
          margin-top = 5;
          margin-bottom = 5;
          margin-left = 5;
          margin-right = 0;
          modules-left = [
            "custom/logo"
            "sway/workspaces"
          ];
          modules-center = [ ];
          modules-right = [
            "tray"
            "group/network-pulseaudio-backlight-battery"
            "clock"
            "group/powermenu"
          ];

          # Distro Logo
          "custom/logo" = {
            format = " ";
            tooltip = false;
          };

          # Workspaces
          "sway/workspaces" = {
            active-only = false;
            disable-scroll = true;
            on-click = "activate";
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              focused = "󰋘";
              default = "󰋙";
              urgent = "󰋙";
            };
            persistent-workspaces = {
              "1" = 1;
              "2" = 2;
              "3" = 3;
              "4" = 4;
              "5" = 5;
            };
          };
          # Group
          "group/network-pulseaudio-backlight-battery" = {
            modules = [
              "network"
              "group/audio-slider"
              "group/light-slider"
              "battery"
            ];
            orientation = "inherit";
          };

          # Network
          network = {
            format-wifi = "󰖩";
            format-ethernet = "󰈀";
            format-disconnected = "󰖪";
            tooltip-format-wifi = "WiFi: {essid} ({signalStrength}%)\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
            tooltip-format-ethernet = "Ethernet: {ifname}\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
            tooltip-format-disconnected = "Disconnected";
            on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
          };

          # Pulseaudio
          "group/audio-slider" = {
            orientation = "inherit";
            drawer = {
              transition-duration = 300;
              children-class = "audio-slider-child";
              transition-left-to-right = false;
            };
            modules = [ "pulseaudio" "pulseaudio/slider" ];
          };
          "pulseaudio/slider" = {
            min = 0;
            max = 100;
            orientation = "vertical";
          };
          pulseaudio = {
            format = "{icon}";
            format-color4tooth = "󰂯";
            format-muted = "󰖁";
            format-icons = {
              default = [ "󰕿" "󰖀" "󰕾" ];
            };
            tooltip-format = "Volume: {volume}%";
            on-click = "${_ pamixer} -t";
            on-scroll-up = "${_ pamixer} -d 1";
            on-scroll-down = "${_ pamixer} -i 1";
          };

          # Backlight
          "group/light-slider" = {
            orientation = "inherit";
            drawer = {
              transition-duration = 300;
              children-class = "light-slider-child";
              transition-left-to-right = false;
            };
            modules = [ "backlight" "backlight/slider" ];
          };
          "backlight/slider" = {
            min = 0;
            max = 100;
            orientation = "vertical";
          };
          backlight = {
            format = "{icon}";
            format-icons = [ "󰝦" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥" ];
            tooltip-format = "Backlight: {percent}%";
            on-scroll-up = "${_ brightnessctl} -q s 1%-";
            on-scroll-down = "${_ brightnessctl} -q s +1%";
          };

          # Battery
          battery = {
            format = "{icon}";
            format-charging = "󱐋";
            format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            format-plugged = "󰚥";
            states = {
              warning = 30;
              critical = 15;
            };
            tooltip-format = "{timeTo}, {capacity}%";
          };

          # Clock & Calendar
          clock = {
            format = "{:%H\n%M}";
            actions = {
              on-scroll-down = "shift_down";
              on-scroll-up = "shift_up";
            };
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              format = {
                days = "<span color='#4A5051'><b>{}</b></span>";
                months = "<span color='#C5C8C9'><b>{}</b></span>";
                today = "<span color='#C5C8C9'><b><u>{}</u></b></span>";
                weekdays = "<span color='#96CDFB'><b>{}</b></span>";
              };
              mode = "month";
              on-scroll = 1;
            };
          };

          # Powermenu
          "group/powermenu" = {
            drawer = {
              children-class = "powermenu-child";
              transition-duration = 300;
              transition-left-to-right = false;
            };
            modules = [
              "custom/power"
              "custom/exit"
              "custom/lock"
              "custom/suspend"
              "custom/reboot"
            ];
            orientation = "inherit";
          };
          "custom/power" = {
            format = "󰐥";
            on-click = "${pkgs.systemd}/bin/systemctl poweroff";
            tooltip = false;
          };
          "custom/exit" = {
            format = "󰈆";
            on-click = "${pkgs.hyprland}/bin/hyprctl dispatch exit";
            tooltip = false;
          };
          "custom/lock" = {
            format = "󰌾";
            on-click = "${pkgs.swaylock-effects}/bin/swaylock -S --daemonize";
            tooltip = false;
          };
          "custom/suspend" = {
            format = "󰤄";
            on-click = "${pkgs.systemd}/bin/systemctl suspend";
            tooltip = false;
          };
          "custom/reboot" = {
            format = "󰜉";
            on-click = "${pkgs.systemd}/bin/systemctl reboot";
            tooltip = false;
          };
        };
      };

      style = ''
        * {
          all: unset;
          font:
            11pt "Material Design Icons",
            "Iosevka Fixed",
            sans-serif;
          min-height: 0;
          min-width: 0;
        }

        label {
          color: #${color7};
        }

        menu,
        tooltip {
          background: #${background};
          border: 1px solid #${mbg};
          border-radius: 0.5rem;
          padding: 0.5rem;
        }

        menu label,
        tooltip label {
          padding: 0.5rem;
        }

        button {
          box-shadow: inset 0 -0.25rem transparent;
          border: none;
        }

        button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
        }

        slider {
          opacity: 0;
          background-image: none;
          border: none;
          box-shadow: none;
        }

        trough {
          min-height: 5rem;
          min-width: 0.625rem;
          border-radius: 0.5rem;
          background-color: #${background};
        }

        highlight {
          min-width: 0.625rem;
          border-radius: 0.5rem;
        }

        window#waybar {
          background: #${background};
          border-radius: 0.5rem;
          color: #${color7};
        }

        .modules-left {
          padding-top: 0.5rem;
        }

        .modules-right {
          padding-bottom: 0.5rem;
        }

        #custom-logo,
        #workspaces,
        #network-pulseaudio-backlight-battery,
        #clock,
        #custom-exit,
        #custom-lock,
        #custom-suspend,
        #custom-reboot,
        #custom-power {
          background: #${mbg};
          border-radius: 1.5rem;
          min-width: 0.75rem;
          margin: 0.25rem 0.5rem;
        }

        #workspaces,
        #network-pulseaudio-backlight-battery,
        #clock {
          padding: 0.75rem 0;
        }

        #workspaces button,
        #network,
        #pulseaudio,
        #pulseaudio-slider,
        #backlight,
        #backlight-slider,
        #battery {
          background: transparent;
          padding: 0.25rem 0.5rem;
        }

        #custom-logo,
        #custom-exit,
        #custom-lock,
        #custom-suspend,
        #custom-reboot,
        #custom-power {
          padding: 0.5rem;
        }

        #custom-logo {
          background: transparent
            url("${snowflake}")
            center/2rem no-repeat;
        }

        #workspaces button label {
          transition: color 0.25s linear;
        }

        #workspaces button.urgent label {
          color: #${color1};
        }

        #workspaces button.special label {
          color: #${color3};
        }

        #workspaces button.active label {
          color: #${color4};
        }

        #network.disconnected,
        #pulseaudio.muted {
          color: #${color1};
        }

        #backlight-slider highlight,
        #pulseaudio-slider highlight {
          background-color: #${color7};
        }

        #battery.charging,
        #battery.plugged {
          color: #${color2};
        }

        #battery.critical:not(.charging) {
          color: #${color1};
          animation: blink 0.5s linear infinite alternate;
        }

        #clock {
          font-weight: bold;
        }

        #custom-exit {
          color: #${color4};
        }

        #custom-lock {
          color: #${color2};
        }

        #custom-suspend {
          color: #${color3};
        }

        #custom-reboot {
          color: #${color11};
        }

        #custom-power {
          color: #${color1};
        }

        @keyframes blink {
          to {
            color: #${color7};
          }
        }
      '';

      systemd.enable = true;
      systemd.target = "graphical-session.target";
    };
}
