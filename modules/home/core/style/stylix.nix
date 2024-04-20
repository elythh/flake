{
  pkgs,
  config,
  ...
}: {
  stylix = {
    base16Scheme = ./${config.theme}.yaml;
    image = ../../../../home/shared/walls/${config.theme}.jpg;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/ashes.yaml";
    polarity = "dark";
    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 20;
    };

    targets = {
      lazygit.enable = false;
      hyprland.enable = false;
      firefox.enable = false;
      fzf.enable = false;
      rofi.enable = false;
      gtk.extraCss = with config.lib.stylix.colors; ''
        @define-color accent_color #${base0D};
        @define-color accent_bg_color #${base0D};
      '';
    };

    fonts = {
      monospace = {
        name = "ZedMono NF";
        package = pkgs.nerdfonts.override {fonts = ["ZedMono"];};
      };
      sansSerif = {
        name = "IBM Plex Sans";
        package = pkgs.ibm-plex;
      };
    };
  };
}
