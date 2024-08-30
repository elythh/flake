{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.apps.discord;
in
{
  options.${namespace}.programs.graphical.apps.discord = {
    enable = mkBoolOpt false "Whether or not to enable Discord.";
    canary.enable = mkBoolOpt false "Whether or not to enable Discord Canary.";
    firefox.enable = mkBoolOpt false "Whether or not to enable the Firefox version of Discord.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = lib.optional cfg.enable pkgs.vesktop;

      activation = {
        # betterdiscordInstall = # bash
        #   home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        #     echo "Running betterdiscord install"
        #     ${getExe pkgs.betterdiscordctl} install || ${getExe pkgs.betterdiscordctl} reinstall || true
        #   '';
      };
    };
  };
}
