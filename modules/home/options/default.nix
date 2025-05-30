{ lib, ... }:
with lib;
{
  options = {
    meadow = {
      modules = {
        gitui.enable = mkEnableOption "Enable gitui";
        gpg-agent.enable = mkEnableOption "Enable gpg-agent";
        k9s.enable = mkEnableOption "Enable k9s";
        lazygit.enable = mkEnableOption "Enable lazygit";
        lf.enable = mkEnableOption "Enable lf";
        rofi.enable = mkEnableOption "Enable rofi";
        sss.enable = mkEnableOption "Enable sss";
        wezterm.enable = mkEnableOption "Enable wezterm";
        zellij.enable = mkEnableOption "Enable zellij";
        zsh.enable = mkEnableOption "Enable zsh";
      };

      default = {
        de = mkOption {
          type = types.enum [
            "niri"
            "hyprland"
          ];
          default = "hyprland";
        };
        browser = mkOption {
          type = types.enum [
            "firefox"
            "qutebrowser"
          ];
          default = "firefox";
        };
        terminal = mkOption {
          type = types.enum [
            "wezterm"
            "foot"
            "kitty"
          ];
          default = "wezterm";
        };
      };
    };
  };
  options.meadow.wallpaper = mkOption {
    type = types.path;
    default = "";
  };
  options.meadow.theme = mkOption {
    type = types.str;
    default = "";
  };
  options.meadow.polarity = mkOption {
    type = types.str;
    default = "dark";
  };
}
