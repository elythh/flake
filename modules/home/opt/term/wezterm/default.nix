{
  config,
  lib,
  nix-colors,
  ...
}:
lib.mkIf (config.default.terminal == "wezterm") {
  home.sessionVariables.TERMINAL = "wezterm";
  programs.wezterm = {
    enable = true;
    colorSchemes = import ./colors.nix {inherit nix-colors config;};
    extraConfig = ''
      local wez = require('wezterm')
      return {
        default_prog     = { 'zsh' },
        cell_width = 0.85,
        -- Performance
        --------------
        enable_wayland   = false,
        scrollback_lines = 1024,
        -- Fonts
        --------
        font         = wez.font_with_fallback({
          "Fantasque Sans M Nerd Font",
          "Material Design Icons",
        }),
        dpi = 96.0,
        bold_brightens_ansi_colors = true,
        font_rules    = {
          {
            italic = true,
            font   = wez.font("JetBrainsMono Nerd Font", { italic = true })
          }
        },
        freetype_load_target = "Normal",
        font_size         = 13.0,
        line_height       = 1.15,
        harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
        -- Bling
        --------
        color_scheme   = "followSystem",
        window_padding = {
          left = "16pt", right = "16pt",
          bottom = "16pt", top = "16pt"
        },
        default_cursor_style = "SteadyUnderline",
        enable_scroll_bar    = false,
        warn_about_missing_glyphs = false,
        -- Tabbar
        ---------
        enable_tab_bar               = true,
        use_fancy_tab_bar            = false,
        hide_tab_bar_if_only_one_tab = true,
        show_tab_index_in_tab_bar    = false,
        -- Miscelaneous
        ---------------
        window_close_confirmation = "NeverPrompt",
        inactive_pane_hsb         = {
          saturation = 1.0, brightness = 0.8
        },
        check_for_updates = false,
        window_background_opacity = 1,
      }
    '';
  };
}
