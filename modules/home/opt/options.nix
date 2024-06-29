{lib, ...}: {
  options = {
    modules = {
      anyrun.enable = lib.mkEnableOption "Enable anyrun";
      cliphist.enable = lib.mkEnableOption "Enable cliphist";
      firefox.enable = lib.mkEnableOption "Enable firefox";
      gitui.enable = lib.mkEnableOption "Enable gitui";
      gpg-agent.enable = lib.mkEnableOption "Enable gpg-agent";
      hyprland.enable = lib.mkEnableOption "Enable hyprland";
      hyprpaper.enable = lib.mkEnableOption "Enable hyprpaper";
      k9s.enable = lib.mkEnableOption "Enable k9s";
      kanshi.enable = lib.mkEnableOption "Enable kanshi";
      lazygit.enable = lib.mkEnableOption "Enable lazygit";
      lf.enable = lib.mkEnableOption "Enable lf";
      mpd.enable = lib.mkEnableOption "Enable mpd";
      ncmpcpp.enable = lib.mkEnableOption "Enable ncmp";
      rbw.enable = lib.mkEnableOption "Enable rbw";
      rofi.enable = lib.mkEnableOption "Enable rofi";
      spicetify.enable = lib.mkEnableOption "Enable spicetify";
      sss.enable = lib.mkEnableOption "Enable sss";
      swaybg.enable = lib.mkEnableOption "Enable swaybg";
      swayfx.enable = lib.mkEnableOption "Enable swayfx";
      swayidle.enable = lib.mkEnableOption "Enable swayidle";
      wezterm.enable = lib.mkEnableOption "Enable wezterm";
      zellij.enable = lib.mkEnableOption "Enable zellij";
      zsh.enable = lib.mkEnableOption "Enable zsh";
    };

    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
    default = {
      de = lib.mkOption {
        type = lib.types.enum ["" "hyprland"];
        default = "hyprland";
      };
      bar = lib.mkOption {
        type = lib.types.enum ["ags" "waybar"];
        default = "ags";
      };
      browser = lib.mkOption {
        type = lib.types.enum ["firefox" "qutebrowser"];
        default = "firefox";
      };
      terminal = lib.mkOption {
        type = lib.types.enum ["wezterm" "foot"];
        default = "wezterm";
      };
      lock = lib.mkOption {
        type = lib.types.enum ["swaylock" "hyprlock"];
        default = "hyprlock";
      };
    };
  };
}
