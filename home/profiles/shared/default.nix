{ ... }:
{
  meadow = {
    style = {
      theme = "fovere";
      polarity = "dark";
    };

    browser.firefox.enable = true;
    browser.zen.enable = true;

    programs = {
      obsidian.enable = true;
      yamlfmt.enable = true;
      yamllint.enable = true;
      rbw.enable = true;
      discord.enable = true;
      rofi.enable = true;
      lazygit.enable = true;
      k9s.enable = true;
      caelestia.enable = false; # Disabled in favor of Noctalia v5
      noctalia.enable = false;
    };

    services = {
      hyprlock.enable = true;
      cliphist.enable = true;
      hyprpaper.enable = true;
      kanshi.enable = true;
      glance.enable = true;
      quicksome.enable = true;
    };
  };
}
