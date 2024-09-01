{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.opt.misc.obsidian;
in
{
  options.opt.misc.rbw = {
    enable = mkEnableOption "Wether to enable Rbw and Rbw-rofi";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rbw
      rofi-rbw
    ];
    sops.secrets.rbw = {
      path = "${config.home.homeDirectory}/.config/rbw/config.json";
    };
  };
}
