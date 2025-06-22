{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
let
  inherit (config.meadow.style) theme polarity;
  inherit (lib) mkOption types;
in
{
  options.meadow.style = {
    wallpaper = mkOption {
      type = types.path;
      default = "";
    };
    theme = mkOption {
      type = types.str;
      default = "";
    };
    polarity = mkOption {
      type = types.str;
      default = "dark";
    };
  };
  config = {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    stylix = {
      enable = true;
      base16Scheme = "${inputs.self}/home/shared/colors/${theme}.yaml";
      image = "${inputs.self}/home/shared/walls/${theme}.jpg";
      polarity = "${polarity}";
      cursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 20;
      };
      opacity = {
        popups = 1.0;
        terminal = 1.0;
      };

      targets = {
        firefox.enable = false;
        fzf.enable = false;
        hyprland.enable = false;
        hyprlock.enable = false;
        lazygit.enable = false;
        waybar.enable = false;
        mako.enable = false;
        nixcord.enable = false;
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
  };
}
