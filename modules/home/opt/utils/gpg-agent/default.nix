{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.modules.gpg-agent.enable {
    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };
}
