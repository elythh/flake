{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.meadow.services.wireguard;
in
{
  options.meadow.services.wireguard.enable = mkEnableOption "wireguard";
  # Enable WireGuard
  config.networking.wireguard.interfaces = mkIf cfg.enable {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "172.20.0.4/24" ];

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/etc/wg.key";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        {
          # Public key of the server (not a file path).
          publicKey = "yXXuXdf9g0+OvRWGfjR6eCKh8616qABhhzMxHb8ydFU=";

          # Forward all the traffic via VPN.
          allowedIPs = [ "0.0.0.0/0" ];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint = "vpn.elyth.xyz:51820";

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
