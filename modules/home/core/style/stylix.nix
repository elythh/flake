{ pkgs, config, ... }:
let
  inherit (config.meadow) theme polarity;
in
{
  stylix = {
    enable = true;
    base16Scheme = ../../../../home/shared/colors/${theme}.yaml;
    image = ../../../../home/shared/walls/${theme}.jpg;
    polarity = "${polarity}";
    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 20;
    };
    opacity = {
      popups = 1.0;
      terminal = 0.5;
    };

    targets = {
      firefox.enable = false;
      fzf.enable = false;
      hyprland.enable = false;
      hyprlock.enable = false;
      lazygit.enable = false;
      waybar.enable = false;
      mako.enable = false;
      gtk.extraCss = with config.lib.stylix.colors; ''
        @define-color accent_color #${base0D};
        @define-color accent_bg_color #${base0D};
      '';
    };

    fonts = {
      sizes.terminal = 13;
      monospace = {
        name = "Iosevka Nerd Font Mono";
        package = pkgs.nerd-fonts.iosevka;
      };
      sansSerif = {
        name = "IBM Plex Sans";
        package = pkgs.ibm-plex;
      };
    };
  };
}
