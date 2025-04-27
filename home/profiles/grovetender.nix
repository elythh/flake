{ inputs, pkgs, ... }:
{

  imports = [
    inputs.stylix.homeManagerModules.stylix
    ../../modules/home
  ];

  meadow = {
    theme = "paradise";
    polarity = "dark";
    opt = {
      browser = {
        firefox.enable = true;
      };
      misc = {
        obsidian.enable = true;
        yamlfmt.enable = true;
        yamllint.enable = true;
        rbw.enable = true;
        discord.enable = true;
      };
      music = {
        spicetify.enable = true;
      };
      launcher = {
        anyrun.enable = false;
        walker.enable = true;
      };
      lock = {
        hyprlock.enable = true;
      };
      services = {
        ags.enable = true;
        cliphist.enable = true;
        hypridle.enable = true;
        hyprpaper.enable = true;
        kanshi.enable = true;
        swaync.enable = false;
        waybar.enable = false;
        glance.enable = true;
      };
      utils = {
        rofi.enable = true;
        lazygit.enable = true;
        k9s.enable = true;
      };
      shell = {
        zellij.enable = true;
      };
    };

    modules = {
      zsh.enable = true;
      gpg-agent.enable = true;
    };

    default = {
      de = "hyprland";
      terminal = "wezterm";
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
