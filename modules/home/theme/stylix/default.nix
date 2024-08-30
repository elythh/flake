{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib)
    mkIf
    types
    mkEnableOption
    ;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.theme;
in
{
  options.${namespace}.theme = with types; {
    enable = mkEnableOption "Wether to enable stylix";
    name = mkOpt str "paradise" "Theme name";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = ./${config.${namespace}.theme.name}.yaml;
      image = lib.snowfall.fs.get-file "modules/home/walls/${config.${namespace}.theme.name}.jpg";

      polarity = "dark";
      cursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 20;
      };
      opacity = {
        popups = 0.7;
      };

      targets = {
        nixvim.enable = true;
        zellij.enable = true;
        lazygit.enable = false;
        hyprland.enable = false;
        firefox.enable = false;
        fzf.enable = false;
        rofi.enable = false;
        waybar.enable = false;
        hyprpaper.enable = true;
        gtk.extraCss = with config.lib.stylix.colors; ''
          @define-color accent_color #${base0D};
          @define-color accent_bg_color #${base0D};
        '';
      };

      fonts = {
        monospace = {
          name = "ZedMono NF";
          package = pkgs.nerdfonts.override { fonts = [ "ZedMono" ]; };
        };
        sansSerif = {
          name = "IBM Plex Sans";
          package = pkgs.ibm-plex;
        };
      };
    };
  };
}
