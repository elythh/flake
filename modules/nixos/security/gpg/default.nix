{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    types
    mkIf
    getExe'
    ;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.security.gpg;

in
{
  options.${namespace}.security.gpg = with types; {
    enable = mkBoolOpt false "Whether or not to enable GPG.";
    agentTimeout = mkOpt int 5 "The amount of time to wait before continuing with shell init.";
  };

  config = mkIf cfg.enable {
    environment.shellInit = # bash
      ''
        ${getExe' pkgs.coreutils "timeout"} ${builtins.toString cfg.agentTimeout} ${getExe' pkgs.gnupg "gpgconf"} --launch gpg-agent
        gpg_agent_timeout_status=$?

        if [ "$gpg_agent_timeout_status" = 124 ]; then
          # Command timed out...
          echo "GPG Agent timed out..."
          echo 'Run "gpgconf --launch gpg-agent" to try and launch it again.'
        fi
      '';

    environment.systemPackages = with pkgs; [
      cryptsetup
      gnupg
      paperkey
      pinentry-curses
      pinentry-qt
    ];

    programs = {
      ssh.startAgent = false;

      gnupg.agent = {
        enable = true;
        enableExtraSocket = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };
    };

    services = {
      pcscd.enable = true;
    };
  };
}
