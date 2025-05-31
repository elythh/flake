{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.meadow.programs.steam = {
    enable = mkEnableOption "steam";
  };
  config = mkIf config.meadow.programs.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
  };
}
