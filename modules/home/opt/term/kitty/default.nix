{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf (config.meadow.default.terminal == "kitty") {
  programs.kitty = {
    enable = true;

    extraConfig = ''
      # Emoji font
      symbol_map U+1F600-U+1F64F Noto Color Emoji

      # Fallback to Nerd Font Symbols
      symbol_map U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6AA,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF,U+F0001-U+F1AF0 Symbols Nerd Font Mono
    '';

    keybindings = {
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+s" = "paste_from_selection";
      "ctrl+shift+c" = "copy_to_clipboard";
      "shift+insert" = "paste_from_selection";

      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+k" = "scroll_line_up";
      "ctrl+shift+j" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";
      "ctrl+shift+h" = "show_scrollback";

      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+n" = "new_os_window";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      "ctrl+shift+f" = "move_window_forward";
      "ctrl+shift+b" = "move_window_backward";
      "ctrl+shift+`" = "move_window_to_top";
      "ctrl+shift+1" = "first_window";
      "ctrl+shift+2" = "second_window";
      "ctrl+shift+3" = "third_window";
      "ctrl+shift+4" = "fourth_window";
      "ctrl+shift+5" = "fifth_window";
      "ctrl+shift+6" = "sixth_window";
      "ctrl+shift+7" = "seventh_window";
      "ctrl+shift+8" = "eighth_window";
      "ctrl+shift+9" = "ninth_window";
      "ctrl+shift+0" = "tenth_window";

      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+l" = "next_layout";
      "ctrl+shift+." = "move_tab_forward";
      "ctrl+shift+," = "move_tab_backward";
      "ctrl+shift+alt+t" = "set_tab_title";

      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
      "ctrl+shift+f6" = "set_font_size 16.0";
    } // lib.optionalAttrs pkgs.stdenv.isDarwin { "cmd+opt+s" = "noop"; };

    settings =
      {
        # Fonts
        italic_font = "auto";
        bold_font = "auto";
        bold_italic_font = "auto";
        font_size = 13;

        adjust_line_height = 0;
        adjust_column_width = 0;
        box_drawing_scale = "0.001, 1, 1.5, 2";

        # Cursor
        cursor_shape = "underline";
        cursor_blink_interval = -1;
        cursor_stop_blinking_after = "15.0";

        # Scrollback
        scrollback_lines = 10000;
        scrollback_pager = "less";
        wheel_scroll_multiplier = "5.0";

        # URLs
        url_style = "double";
        # FIXME: removed option https://sw.kovidgoyal.net/kitty/changelog/#id41
        # open_url_modifiers = "ctrl + shift";
        open_url_with = "gio open";
        copy_on_select = "yes";

        # Selection
        # FIXME: removed option https://sw.kovidgoyal.net/kitty/changelog/#id41
        # rectangle_select_modifiers = "ctrl + shift";
        select_by_word_characters = ":@-./_~?& = %+#";

        # Mouse
        click_interval = "0.5";
        mouse_hide_wait = 0;
        focus_follows_mouse = "no";

        # Performance
        repaint_delay = 20;
        input_delay = 2;
        sync_to_monitor = "no";

        # Bell
        visual_bell_duration = "0.0";
        enable_audio_bell = "yes";
        bell_on_tab = "yes";

        # Window
        remember_window_size = "no";
        initial_window_width = 700;
        initial_window_height = 400;
        window_border_width = 0;
        window_margin_width = 0;
        window_padding_width = 0;
        inactive_text_alpha = "1.0";
        placement_strategy = "center";
        hide_window_decorations = "yes";
        confirm_os_window_close = -1;
        # 0 if you dont want confirmation to close kitty instances with running commands

        # Layouts
        enabled_layouts = "*";

        # Shell
        shell = ".";
        close_on_child_death = "no";
        allow_remote_control = "yes";
        term = "xterm-kitty";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        hide_window_decorations = "titlebar-only";
        macos_option_as_alt = "both";
        macos_custom_beam_cursor = "yes";
        macos_thicken_font = 0;
        macos_colorspace = "displayp3";
      };

    shellIntegration = {
      enableZshIntegration = true;
    };
  };
}
