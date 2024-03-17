{config, ...}: {
  home.sessionVariables.TERMINAL = "foot";
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka Nerd Font:size=12";
        dpi-aware = "yes";
        line-height = 16;
        pad = "16x16";
        vertical-letter-offset = "3px";
      };

      cursor = {
        color = "111516 c2c4c2";
      };

      colors = with config.colorscheme.palette; {
        alpha = 0.9;

        background = "${background}";
        foreground = "${foreground}";
        regular0 = "${color0}";
        regular1 = "${color1}";
        regular2 = "${color2}";
        regular3 = "${color3}";
        regular4 = "${color4}";
        regular5 = "${color5}";
        regular6 = "${color6}";
        regular7 = "${color7}";

        bright0 = "${color8}";
        bright1 = "${color9}";
        bright2 = "${color10}";
        bright3 = "${color11}";
        bright4 = "${color12}";
        bright5 = "${color13}";
        bright6 = "${color14}";
        bright7 = "${color15}";
      };
    };
  };
}