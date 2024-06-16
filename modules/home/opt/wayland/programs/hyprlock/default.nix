{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.default.lock == "hyprlock" && config.default.de == "hyprland") {
    programs.hyprlock = with config.lib.stylix.colors; {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -90";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "${base05}";
            inner_color = "${base01}";
            outer_color = "${base01}";
            outline_thickness = 5;
            placeholder_text = "Password...";
            shadow_passes = 2;
          }
        ];
        # Time
        label = [
          {
            text = "cmd[update:1000] echo \"$(date +'%-I:%M%p')\"";
            color = "${base05}";
            font_size = 120;
            font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
            position = "0, -300";
            halign = "center";
            valign = "top";
          }
          # User
          {
            text = "Hi there, $USER";
            color = "${base05}";
            font_size = 25;
            font_family = "JetBrains Mono Nerd Font Mono";
            position = "0, -40";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
