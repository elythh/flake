{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption getExe;
  cfg = config.meadow.services.quicksome;
  quicksomePkg = inputs.quicksome.packages.${pkgs.system}.default;
in
{
  options.meadow.services.quicksome.enable = mkEnableOption "quicksome Quickshell bar";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.quickshell ];

    systemd.user.services.quicksome = {
      Unit = {
        Description = "Quicksome Quickshell Hyprland bar";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${getExe pkgs.quickshell} --path ${quicksomePkg}/share/quickshell";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
