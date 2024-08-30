{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.${namespace}.system.networking;
in
{
  config = mkIf cfg.enable {
    elyth.user.extraGroups = [ "networkmanager" ];

    networking.networkmanager = {
      enable = true;

      connectionConfig = {
        "connection.mdns" = "2";
      };

      plugins = with pkgs; [
        networkmanager-l2tp
        networkmanager-openvpn
        networkmanager-sstp
        networkmanager-vpnc
      ];

      unmanaged = [
        "interface-name:br-*"
        "interface-name:rndis*"
      ] ++ lib.optionals config.${namespace}.services.tailscale.enable [ "interface-name:tailscale*" ];
    };

    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  };
}
