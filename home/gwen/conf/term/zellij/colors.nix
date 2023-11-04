{ nix-colors, config, ... }:

with config.colorscheme.colors; {
  # basic colors
  bg = "#${background}";
  fg = "#${foreground}";
  black = "#${background}";
  red = "#${color9}";
  green = "#${color4}";
  yellow = "#${color3}";
  blue = "#${color4}";
  magenta = "#${color5}";
  cyan = "#${color6}";
  white = "#${color7}";
  orange = "#${color11}";
}
