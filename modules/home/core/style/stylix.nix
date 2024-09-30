{ pkgs, config, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = ./${config.theme}.yaml;
    image = ../../../../home/shared/walls/${config.theme}.jpg;
    polarity = "dark";
    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 20;
    };
    opacity = {
      popups = 1.0;
    };

    targets = {
      nixvim.enable = true;
      zellij.enable = true;
      lazygit.enable = false;
      hyprland.enable = false;
      firefox.enable = false;
      fzf.enable = false;
      rofi.enable = true;
      waybar.enable = false;
      gtk.enable = true;
      gtk.extraCss = with config.lib.stylix.colors; ''
        @define-color accent_color #${base0D};
        @define-color accent_bg_color #${base0D};
      '';
    };

    fonts = {
      monospace = {
        name = "Iosevka Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; };
      };
      sansSerif = {
        name = "IBM Plex Sans";
        package = pkgs.ibm-plex;
      };
    };
  };
}
