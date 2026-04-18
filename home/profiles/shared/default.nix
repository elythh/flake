{ ... }:
{
  meadow = {
    style = {
      theme = "paradise";
      polarity = "dark";
    };

    browser.firefox.enable = true;

    programs = {
      obsidian.enable = true;
      yamlfmt.enable = true;
      yamllint.enable = true;
      rbw.enable = true;
      discord.enable = true;
      rofi.enable = true;
      lazygit.enable = true;
      k9s.enable = true;
      quickshell.enable = true;
    };

    services = {
      hyprlock.enable = true;
      cliphist.enable = true;
      hyprpaper.enable = true;
      kanshi.enable = true;
      swaync.enable = false;
      waybar.enable = false;
      glance.enable = true;
    };

    default.wm = "hyprland";
  };
}
