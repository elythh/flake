{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  # all of it taken from nixos/modules/services/web-apps/your_spotify.nix
  inherit (lib)
    boolToString
    concatMapAttrs
    concatStrings
    isBool
    mapAttrsToList
    mkForce
    optionalAttrs
    ;
  nginxClientPort = 3222;
  clientEndpoint = "localhost:${toString nginxClientPort}";
  settings = rec {
    PORT = 3111;
    CLIENT_ENDPOINT = "http://${clientEndpoint}";
    API_ENDPOINT = "http://localhost:${toString PORT}";
    # all this is a workaround for keeping this secret
    # SPOTIFY_PUBLIC = config.sops.secrets.your_spotify_client_id_env.path;
    MONGO_ENDPOINT = "mongodb://localhost:27017/your_spotify";
  };
  configEnv = concatMapAttrs (
    name: value:
    optionalAttrs (value != null) {
      ${name} = if isBool value then boolToString value else toString value;
    }
  ) settings;
  configFile = pkgs.writeText "your_spotify_overriden.env" (
    concatStrings (mapAttrsToList (name: value: "${name}=${value}\n") configEnv)
  );
in
{
  sops.secrets.your_spotify_client_secret = { };
  sops.secrets.your_spotify_client_id_env = { };
  services.your_spotify = {
    enable = true;
    enableLocalDB = true;
    nginxVirtualHost = clientEndpoint;
    inherit settings;
    spotifySecretFile = config.sops.secrets.your_spotify_client_secret.path;
  };
  systemd.services.your_spotify.serviceConfig.EnvironmentFile = mkForce [
    configFile
    config.sops.secrets.your_spotify_client_id_env.path
  ];
  services.nginx.virtualHosts.${config.services.your_spotify.nginxVirtualHost}.listen = [
    {
      addr = "localhost";
      port = nginxClientPort;
    }
  ];
}
