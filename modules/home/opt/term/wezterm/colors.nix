{config, ...}:
with config.lib.stylix.colors; {
  followSystem = {
    # basic colors
    background = "#${base00}";
    cursor_bg = "#${base05}";
    cursor_border = "#${base05}";
    cursor_fg = "#${base0A}";
    foreground = "#${base05}";
    selection_bg = "#${base01}";
    selection_fg = "#${base05}";
    split = "#${base01}";

    # base16
    ansi = [
      "#${base01}"
      "#${base08}"
      "#${base0B}"
      "#${base0A}"
      "#${base0D}"
      "#${base0E}"
      "#${base0C}"
      "#${base05}"
    ];
    brights = [
      "#${base03}"
      "#${base08}"
      "#${base0B}"
      "#${base0A}"
      "#${base0D}"
      "#${base0E}"
      "#${base0C}"
      "#${base0F}"
    ];
  };
}
