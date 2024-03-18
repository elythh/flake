{
  config,
  pkgs,
  ...
}: {
  stylix = {
    image = config.wallpaper;
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
    };
    fonts = {
      serif = {
        package = pkgs.nerdfonts;
        name = "FiraCode Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.lexend;
        name = "Lexend";
      };
      monospace = {
        package = pkgs.nerdfonts;
        name = "FiraCode Nerd Font Mono";
      };
      sizes = {
        desktop = 11;
        applications = 11;
        terminal = 11;
        popups = 11;
      };
    };
    polarity = "dark";
    targets = {
      hyprland.enable = false;
      k9s.enable = false;
      rofi.enable = false;
      swaylock.enable = false;
    };
  };
}
