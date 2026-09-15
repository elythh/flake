{
  lib,
  ...
}:
{
  meadow = {
    style = {
      theme = "paradise";
      polarity = "dark";
    };

    browser.firefox.enable = false;
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
      caelestia.enable = lib.mkDefault false;
      noctalia.enable = lib.mkDefault false;
      dank-material-shell.enable = lib.mkDefault false;
    };

    services = {
      hyprlock.enable = true;
      cliphist.enable = true;
      hyprpaper.enable = true;
      kanshi.enable = true;
      glance.enable = true;
      quicksome.enable = lib.mkDefault true;
    };
  };
}
