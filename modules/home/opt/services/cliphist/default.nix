{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.opt.services.cliphist;
in
{
  options.opt.services.cliphist.enable = mkEnableOption "cliphist";

  config = mkIf cfg.enable {
    systemd.user.services.cliphist = {
      Unit = {
        Description = "Clipboard history";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${lib.getBin pkgs.cliphist}/cliphist store";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
