{ inputs, pkgs, ... }:
{

  imports = [
    inputs.stylix.homeManagerModules.stylix
    ../../modules/home
  ];
  meadow = {
    theme = "houseki";
    polarity = "dark";
    modules = {
      zsh.enable = true;
      gpg-agent.enable = true;
    };

    default = {
      de = "hyprland";
      terminal = "foot";
    };
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
        cliphist.enable = true;
        hypridle.enable = true;
        hyprpaper.enable = true;
        kanshi.enable = true;
        # swaync.enable = true;
        # waybar.enable = true;
        ags.enable = true;

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
  };

  # Specific packages for this home-manager host config
  home = {
    packages = with pkgs; [
      teeworlds # very important to work
      distrobox
    ];
  };
}
