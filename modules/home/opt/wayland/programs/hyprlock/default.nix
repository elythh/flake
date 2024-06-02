{
  inputs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.default.lock == "hyprlock" && config.default.de == "hyprland") {
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = false;
          hide_cursor = true;
          grace = 2;
          no_fade_in = false;
        };
        backgrounds = [
          {
            path = "${config.wallpaper}";

            # Blur
            blur_passes = 7; # 0 disables blurring
            blur_size = 8;
            noise = 1.17e-2;
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
          }
        ];

        input-fields = [
          {
            size = {
              width = 300;
              height = 50;
            };
            outline_thickness = 3;
            dots_size = 0.33;
            dots_spacing = 0.15;
            dots_center = true;
            outer_color = "rgba(255, 255, 255, 0.1)";
            inner_color = "rgba(255, 255, 255, 0.1)";
            font_color = "rgb(255, 255, 255)";
            fade_on_empty = true;
            placeholder_text = "<i>Input Password...</i>";
            hide_input = false;
            position = {
              x = 0;
              y = -100;
            };
            halign = "center";
            valign = "center";
          }
        ];

        labels = [
          {
            text = "<b>$TIME</b>";
            color = "rgb(255, 255, 255)";
            font_size = 120;
            position = {
              x = 0;
              y = -40;
            };
            halign = "center";
            valign = "top";
          }
          {
            text = ''cmd[update:1000] echo "$(date "+%a %d %b")"'';
            color = "rgb(255, 255, 255)";
            font_size = 24;
            position = {
              x = 0;
              y = -220;
            };
            halign = "center";
            valign = "top";
          }
          {
            text = "Don't touch !";
            color = "rgb(255, 255, 255)";
            font_size = 32;
            position = {
              x = 0;
              y = 0;
            };
            halign = "center";
            valign = "center";
          }
          {
            text = "Unless your name is <i>$USER</i>";
            color = "rgb(255, 255, 255)";
            font_size = 32;
            position = {
              x = 0;
              y = -43;
            };
            halign = "center";
            valign = "center";
          }
          {
            text = "cmd[] echo ' '";
            color = "rgb(255, 255, 255)";
            font_size = 50;
            position = {
              x = 0;
              y = 0;
            };
            halign = "center";
            valign = "bottom";
          }
        ];
      };
    };
  };
}
