{ pkgs, config, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = ./${config.theme}.yaml;
    image = ../../../../home/shared/walls/${config.theme}.jpg;
    polarity = "${config.polarity}";
    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 20;
    };
    opacity = {
      popups = 1.0;
      terminal = 0.88;
    };

    targets = {
      firefox.enable = false;
      foot.enable = true;
      fzf.enable = false;
      hyprland.enable = false;
      hyprlock.enable = false;
      lazygit.enable = false;
      nixvim.enable = true;
      rofi.enable = true;
      waybar.enable = false;
      zellij.enable = true;
      gtk.enable = true;
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
