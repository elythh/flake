{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.stylix.homeModules.stylix
    ../../modules/home
  ];

  meadow = {
    style = {
      theme = "paradise";
      polarity = "dark";
    };
    browser = {
      firefox.enable = true;
    };
    programs = {
      ax-shell.enable = false;
      obsidian.enable = true;
      yamlfmt.enable = true;
      yamllint.enable = true;
      rbw.enable = true;
      discord.enable = true;
      spicetify.enable = true;
      zellij.enable = true;
      rofi.enable = true;
      lazygit.enable = true;
      k9s.enable = true;
      quickshell.enable = true;
    };

    services = {
      hyprlock.enable = true;
      ags.enable = true;
      cliphist.enable = true;
      hypridle.enable = true;
      hyprpaper.enable = true;
      kanshi.enable = true;
      swaync.enable = false;
      waybar.enable = false;
      glance.enable = true;
    };

    default = {
      shell = [
        "fish"
        "zsh"
      ];
      wm = "hyprland";
      terminal = "foot";
    };
  };

  # Specific packages for this home-manager host config
  home = {
    packages = with pkgs; [
      android-tools
      lunar-client
      scrcpy
      stremio
      equicord
      wdisplays
      yazi
      # affine
    ];
  };
}
