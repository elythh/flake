{ pkgs, colors, ... }:

with colors; {
  programs.kitty = {
    enable = true;
    settings = { };
    extraConfig = ''
      linux_display_server wayland
      wayland_titlebar_color background

      font_family Iosevka Nerd Font 
      bold_font        auto
      italic_font      auto
      bold_italic_font auto

      font_size 12
      background_opacity 0.3

      # window settings
      initial_window_width 95c
      initial_window_height 35c
      window_padding_width 20
      confirm_os_window_close 0

      # Upstream colors {{{

      background #${colors.background}
      foreground #${colors.foreground}
      cursor     #${colors.foreground}

      # Black
      color0 #${colors.color0}
      color8 #${colors.color0}

      # Red
      color1 #${colors.color1}
      color9 #${colors.color9}

      # Green
      color2 #${colors.color2}
      color10 #${colors.color10}

      # Yellow
      color3  #${colors.color3}
      color11 #${colors.color11}

      # Blue
      color4 #${colors.color4}
      color12 #${colors.color12}

      # Magenta
      color5 #${colors.color5}
      color13 #${colors.color13}

      # Cyan
      color6 #${colors.color6}
      color14 #${colors.color14}
      # White
      color7 #${colors.color7}
      color15 #${colors.color15}


      # The color for highlighting URLs on mouse-over
      # url_color #9ece6a
      url color #5de4c7

      # Window borders
      active_border_color #3d59a1
      inactive_border_color #101014
      bell_border_color #fffac2

      # Tab bar
      tab_bar_style fade
      tab_fade 1
      active_tab_foreground   #3d59a1
      active_tab_background   #16161e
      active_tab_font_style   bold
      inactive_tab_foreground #787c99
      inactive_tab_background #16161e
      inactive_tab_font_style bold
      tab_bar_background #101014

      # Title bar
      macos_titlebar_color #16161e

      # {{{ Keybindings
      map kitty_mod+t     new_tab_with_cwd
      # }}

    '';
  };
}
