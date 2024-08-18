# Auto-generated using compose2nix v0.2.2-pre.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."mc-filebrowser" = {
    image = "filebrowser/filebrowser:latest";
    volumes = [
      "/home/mithrix/Documents/mc2/data/filebrowser/filebrowser.db:/database.db:rw"
      "/home/mithrix/Documents/mc2/data/minecraft:/srv:rw"
    ];
    ports = [ "8080:80/tcp" ];
    cmd = [ "--noauth" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=filebrowser"
      "--network=proxy"
      "--security-opt=no-new-privileges:true"
    ];
  };
  systemd.services."docker-mc-filebrowser" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    partOf = [ "docker-compose-mc-root.target" ];
    wantedBy = [ "docker-compose-mc-root.target" ];
  };
  virtualisation.oci-containers.containers."mc-proxy" = {
    image = "itzg/bungeecord:latest";
    environment = {
      "ENABLE_RCON" = "true";
      "MAX_MEMORY" = "2G";
      "MEMORY" = "1G";
      "SPIGET_PLUGINS" = "19254,2124";
      "TYPE" = "VELOCITY";
    };
    volumes = [ "/home/mithrix/Documents/mc2/data/minecraft/proxy:/server:rw" ];
    ports = [
      "25565:25577/tcp"
      "19132:19132/tcp"
      "8804:8804/tcp"
      "25565:25577/udp"
      "19132:19132/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc-proxy"
      "--network=mc-backend"
    ];
  };
  systemd.services."docker-mc-proxy" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [ "docker-network-mc-backend.service" ];
    requires = [ "docker-network-mc-backend.service" ];
    partOf = [ "docker-compose-mc-root.target" ];
    wantedBy = [ "docker-compose-mc-root.target" ];
  };
  virtualisation.oci-containers.containers."mc1" = {
    image = "itzg/minecraft-server";
    environment = {
      "ENABLE_COMMAND_BLOCK" = "true";
      "EULA" = "TRUE";
      "ICON" = "https://cdn.7tv.app/emote/64b7b8b5642afce8d4f4907f/4x.webp";
      "MAX_PLAYERS" = "30";
      "MEMORY" = "2G";
      "MOTD" = "\\u00A7ksdfgkljgdfgsdfjgldgfsg";
      "ONLINE_MODE" = "false";
      "SPIGET_RESOURCES" = "2124";
      "TYPE" = "paper";
      "VERSION" = "1.20.6";
      "WORLD" = "https://hielkemaps.com/downloads/Parkour%20Spiral%202.zip";
    };
    volumes = [ "/home/mithrix/Documents/mc2/data/minecraft/mc1:/data:rw" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc1"
      "--network=mc-backend"
    ];
  };
  systemd.services."docker-mc1" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "no";
    };
    after = [ "docker-network-mc-backend.service" ];
    requires = [ "docker-network-mc-backend.service" ];
    partOf = [ "docker-compose-mc-root.target" ];
    wantedBy = [ "docker-compose-mc-root.target" ];
  };
  virtualisation.oci-containers.containers."mc2" = {
    image = "itzg/minecraft-server";
    environment = {
      "EULA" = "true";
      "ICON" = "https://cdn.7tv.app/emote/64b7b8b5642afce8d4f4907f/4x.webp";
      "MEMORY" = "4G";
      "ONLINE_MODE" = "false";
      "SPIGET_RESOURCES" = "2124,96927,20400,88135";
      "TYPE" = "PAPER";
      "VERSION" = "1.20.6";
    };
    volumes = [ "/home/mithrix/Documents/mc2/data/minecraft/mc2:/data:rw" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc2"
      "--network=mc-backend"
    ];
  };
  systemd.services."docker-mc2" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [ "docker-network-mc-backend.service" ];
    requires = [ "docker-network-mc-backend.service" ];
    partOf = [ "docker-compose-mc-root.target" ];
    wantedBy = [ "docker-compose-mc-root.target" ];
  };
  virtualisation.oci-containers.containers."mc3" = {
    image = "itzg/minecraft-server:java8";
    environment = {
      "ENABLE_COMMAND_BLOCK" = "true";
      "EULA" = "TRUE";
      "MAX_PLAYERS" = "30";
      "MEMORY" = "12G";
      "MOTD" = "\\u00A7ksdfgkljgdfgsdfjgldgfsg";
      "ONLINE_MODE" = "false";
      "PLUGINS" = "https://github.com/MonkeyDevelopment/RoofedMaker/releases/download/version1_Patch3/RoofedMaker.jar ";
      "SPIGET_RESOURCES" = "73113,99923";
      "TYPE" = "PAPER";
      "VERSION" = "1.8.8";
    };
    volumes = [ "/home/mithrix/Documents/mc2/data/minecraft/mc3:/data:rw" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc3"
      "--network=mc-backend"
    ];
  };
  systemd.services."docker-mc3" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "no";
    };
    after = [ "docker-network-mc-backend.service" ];
    requires = [ "docker-network-mc-backend.service" ];
    partOf = [ "docker-compose-mc-root.target" ];
    wantedBy = [ "docker-compose-mc-root.target" ];
  };
  virtualisation.oci-containers.containers."mc6" = {
    image = "itzg/minecraft-server:java8";
    environment = {
      "ENABLE_COMMAND_BLOCK" = "true";
      "EULA" = "TRUE";
      "ICON" = "https://cdn.7tv.app/emote/64b7b8b5642afce8d4f4907f/4x.webp";
      "MAX_PLAYERS" = "30";
      "MEMORY" = "4G";
      "MOTD" = "\\u00A7ksdfgkljgdfgsdfjgldgfsg";
      "ONLINE_MODE" = "false";
      "SPIGET_RESOURCES" = "1997,2124";
      "TYPE" = "paper";
      "VERSION" = "1.15.1";
      "WORLD" = "https://github.com/leomelki/LoupGarou/raw/master/maps/lg_village.zip";
    };
    volumes = [ "/home/mithrix/Documents/mc2/data/minecraft/mc6:/data:rw" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc6"
      "--network=mc-backend"
    ];
  };
  systemd.services."docker-mc6" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "no";
    };
    after = [ "docker-network-mc-backend.service" ];
    requires = [ "docker-network-mc-backend.service" ];
    partOf = [ "docker-compose-mc-root.target" ];
    wantedBy = [ "docker-compose-mc-root.target" ];
  };
  virtualisation.oci-containers.containers."parcour" = {
    image = "itzg/minecraft-server";
    environment = {
      "ENABLE_COMMAND_BLOCK" = "true";
      "EULA" = "TRUE";
      "MAX_PLAYERS" = "30";
      "MEMORY" = "4G";
      "MOTD" = "\\u00A7ksdfgkljgdfgsdfjgldgfsg";
      "ONLINE_MODE" = "false";
      "TYPE" = "paper";
      "VERSION" = "1.19.4";
    };
    volumes = [ "/home/mithrix/Documents/mc2/data/minecraft/parcour:/data:rw" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=parcours"
      "--network=mc-backend"
    ];
  };
  systemd.services."docker-parcour" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "no";
    };
    after = [ "docker-network-mc-backend.service" ];
    requires = [ "docker-network-mc-backend.service" ];
    partOf = [ "docker-compose-mc-root.target" ];
    wantedBy = [ "docker-compose-mc-root.target" ];
  };
  virtualisation.oci-containers.containers."adventure" = {
    image = "itzg/minecraft-server";
    environment = {
      "ENABLE_COMMAND_BLOCK" = "true";
      "EULA" = "TRUE";
      "MAX_PLAYERS" = "30";
      "MEMORY" = "4G";
      "MOTD" = "\\u00A7ksdfgkljgdfgsdfjgldgfsg";
      "ONLINE_MODE" = "false";
      "TYPE" = "paper";
      "VERSION" = "1.19.2";
      "WORLD" = "https://download2285.mediafire.com/bmifz9hqdr5gPQpEirntVU0_NBwLNSUlRDdA02ocWQ3D4nL9x4b5CFCYEu9cSS1xOgYLSSYnatoqdq_5yAoX_c-eQIdwM9gabtsU6eBd6GqmuZsL-eYGYY0-iflwt7QYWPPnft1iVF4c-bXk1AX4G5vka5hVINOvo-FeZoDhXw/pkbniz6dpnww76s/Cheap+House.zip";
    };
    volumes = [ "/home/mithrix/Documents/mc2/data/minecraft/adventure:/data:rw" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=adventure"
      "--network=mc-backend"
    ];
  };
  systemd.services."docker-adventure" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "no";
    };
    after = [ "docker-network-mc-backend.service" ];
    requires = [ "docker-network-mc-backend.service" ];
    partOf = [ "docker-compose-mc-root.target" ];
    wantedBy = [ "docker-compose-mc-root.target" ];
  };

  # Networks
  systemd.services."docker-network-mc-backend" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f mc-backend";
    };
    script = ''
      docker network inspect mc-backend || docker network create mc-backend --driver=bridge
    '';
    partOf = [ "docker-compose-mc-root.target" ];
    wantedBy = [ "docker-compose-mc-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-mc-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
