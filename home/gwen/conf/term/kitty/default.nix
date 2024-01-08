{ pkgs, config, nix-colors, ... }:

with config.colorscheme.colors; {
  home.sessionVariables.TERMINAL = "kitty";
  programs.kitty = {
    enable = true;
    settings = { };
    extraConfig = ''
      linux_display_server wayland

      font_family Iosevka Nerd Font 
      bold_font        auto
      italic_font      auto
      bold_italic_font auto

      font_size 12
      background_opacity 0.7

      # window settings
      initial_window_width 95c
      initial_window_height 35c
      window_padding_width 20
      confirm_os_window_close 0

      # Upstream colors {{{

      background #${background}
      foreground #${foreground}
      cursor     #${foreground}

      # Black
      color0 #${color0}
      color8 #${color0}

      # Red
      color1 #${color1}
      color9 #${color9}

      # Green
      color2 #${color2}
      color10 #${color10}

      # Yellow
      color3  #${color3}
      color11 #${color11}

      # Blue
      color4 #${color4}
      color12 #${color12}

      # Magenta
      color5 #${color5}
      color13 #${color13}

      # Cyan
      color6 #${color6}
      color14 #${color14}
      # White
      color7 #${color7}
      color15 #${color15}


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
