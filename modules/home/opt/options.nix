{ lib, ... }:
{
  options = {
    modules = {
      gitui.enable = lib.mkEnableOption "Enable gitui";
      gpg-agent.enable = lib.mkEnableOption "Enable gpg-agent";
      k9s.enable = lib.mkEnableOption "Enable k9s";
      lazygit.enable = lib.mkEnableOption "Enable lazygit";
      lf.enable = lib.mkEnableOption "Enable lf";
      rofi.enable = lib.mkEnableOption "Enable rofi";
      sss.enable = lib.mkEnableOption "Enable sss";
      wezterm.enable = lib.mkEnableOption "Enable wezterm";
      zellij.enable = lib.mkEnableOption "Enable zellij";
      zsh.enable = lib.mkEnableOption "Enable zsh";
    };

    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
    default = {
      de = lib.mkOption {
        type = lib.types.enum [
          ""
          "hyprland"
        ];
        default = "hyprland";
      };
      browser = lib.mkOption {
        type = lib.types.enum [
          "firefox"
          "qutebrowser"
        ];
        default = "firefox";
      };
      terminal = lib.mkOption {
        type = lib.types.enum [
          "wezterm"
          "foot"
        ];
        default = "wezterm";
      };
    };
  };
}
