{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers = {
      proxy = {
        enable = true;
        package = pkgs.velocityServers.velocity;
        serverProperties = {
          server-port = 25565;
        };
        symlinks = {
          "velocity.toml" = pkgs.writeTextFile {
            name = "velocity.toml";
            text = ''
              # Config version. Do not change this
              config-version = "2.7"

              # What port should the proxy be bound to? By default, we'll bind to all addresses on port 25577.
              bind = "0.0.0.0:25565"

              # What should be the MOTD? This gets displayed when the player adds your server to
              # their server list. Only MiniMessage format is accepted.
              # motd = "<underlined><red>Serveur de la <bold>BookyyCorp</bold></red>"

              # What should we display for the maximum number of players? (Velocity does not support a cap
              # on the number of players online.)
              show-max-players = 100

              # Should we authenticate players with Mojang? By default, this is on.
              online-mode = true

              # Should the proxy enforce the new public key security standard? By default, this is on.
              force-key-authentication = true

              # If client's ISP/AS sent from this proxy is different from the one from Mojang's
              # authentication server, the player is kicked. This disallows some VPN and proxy
              # connections but is a weak form of protection.
              prevent-client-proxy-connections = false

              # Should we forward IP addresses and other data to backend servers?
              # Available options:
              # - "none":        No forwarding will be done. All players will appear to be connecting
              #                  from the proxy and will have offline-mode UUIDs.
              # - "legacy":      Forward player IPs and UUIDs in a BungeeCord-compatible format. Use this
              #                  if you run servers using Minecraft 1.12 or lower.
              # - "bungeeguard": Forward player IPs and UUIDs in a format supported by the BungeeGuard
              #                  plugin. Use this if you run servers using Minecraft 1.12 or lower, and are
              #                  unable to implement network level firewalling (on a shared host).
              # - "modern":      Forward player IPs and UUIDs as part of the login process using
              #                  Velocity's native forwarding. Only applicable for Minecraft 1.13 or higher.
              player-info-forwarding-mode = "legacy"

              # If you are using modern or BungeeGuard IP forwarding, configure a file that contains a unique secret here.
              # The file is expected to be UTF-8 encoded and not empty.
              forwarding-secret-file = "forwarding.secret"

              # Announce whether or not your server supports Forge. If you run a modded server, we
              # suggest turning this on.
              #
              # If your network runs one modpack consistently, consider using ping-passthrough = "mods"
              # instead for a nicer display in the server list.
              announce-forge = false

              # If enabled (default is false) and the proxy is in online mode, Velocity will kick
              # any existing player who is online if a duplicate connection attempt is made.
              kick-existing-players = false

              # Should Velocity pass server list ping requests to a backend server?
              # Available options:
              # - "disabled":    No pass-through will be done. The velocity.toml and server-icon.png
              #                  will determine the initial server list ping response.
              # - "mods":        Passes only the mod list from your backend server into the response.
              #                  The first server in your try list (or forced host) with a mod list will be
              #                  used. If no backend servers can be contacted, Velocity won't display any
              #                  mod information.
              # - "description": Uses the description and mod list from the backend server. The first
              #                  server in the try (or forced host) list that responds is used for the
              #                  description and mod list.
              # - "all":         Uses the backend server's response as the proxy response. The Velocity
              #                  configuration is used if no servers could be contacted.
              ping-passthrough = "DISABLED"

              # If not enabled (default is true) player IP addresses will be replaced by <ip address withheld> in logs
              enable-player-address-logging = true

              [servers]
              # Configure your servers here. Each key represents the server's name, and the value
              # represents the IP address of the server to connect to.
              adventure = "127.0.0.1:25568"

              # In what order we should try servers when a player logs in or is kicked from a server.
              try = [
                  "adventure"
              ]

              [forced-hosts]
              # Configure your forced hosts here.
              "lobby.booky.cool" = [
                  "adventure"
              ]

              [advanced]
              # How large a Minecraft packet has to be before we compress it. Setting this to zero will
              # compress all packets, and setting it to -1 will disable compression entirely.
              compression-threshold = 256

              # How much compression should be done (from 0-9). The default is -1, which uses the
              # default level of 6.
              compression-level = -1

              # How fast (in milliseconds) are clients allowed to connect after the last connection? By
              # default, this is three seconds. Disable this by setting this to 0.
              login-ratelimit = 3000

              # Specify a custom timeout for connection timeouts here. The default is five seconds.
              connection-timeout = 5000

              # Specify a read timeout for connections here. The default is 30 seconds.
              read-timeout = 30000

              # Enables compatibility with HAProxy's PROXY protocol. If you don't know what this is for, then
              # don't enable it.
              haproxy-protocol = false

              # Enables TCP fast open support on the proxy. Requires the proxy to run on Linux.
              tcp-fast-open = false

              # Enables BungeeCord plugin messaging channel support on Velocity.
              bungee-plugin-message-channel = true

              # Shows ping requests to the proxy from clients.
              show-ping-requests = false

              # By default, Velocity will attempt to gracefully handle situations where the user unexpectedly
              # loses connection to the server without an explicit disconnect message by attempting to fall the
              # user back, except in the case of read timeouts. BungeeCord will disconnect the user instead. You
              # can disable this setting to use the BungeeCord behavior.
              failover-on-unexpected-server-disconnect = true

              # Declares the proxy commands to 1.13+ clients.
              announce-proxy-commands = true

              # Enables the logging of commands
              log-command-executions = false

              # Enables logging of player connections when connecting to the proxy, switching servers
              # and disconnecting from the proxy.
              log-player-connections = true

              # Allows players transferred from other hosts via the
              # Transfer packet (Minecraft 1.20.5) to be received.
              accepts-transfers = false

              [query]
              # Whether to enable responding to GameSpy 4 query responses or not.
              enabled = false

              # If query is enabled, on what port should the query protocol listen on?
              port = 25565

              # This is the map name that is reported to the query services.
              map = "Velocity"

              # Whether plugins should be shown in query response by default or not
              show-plugins = true
            '';
          };
          "plugins" = pkgs.linkFarmFromDrvs "plugins" (
            builtins.attrValues {
              ViaRewind = pkgs.fetchurl {
                url = "https://hangarcdn.papermc.io/plugins/ViaVersion/ViaRewind/versions/4.0.2/PAPER/ViaRewind-4.0.2.jar";
                hash = "sha256-F2JBPSnIIt+i/JiRzgklVUC51QZ1leZOLiNYeFiLopk=";
              };
              ViaVersion = pkgs.fetchurl {
                url = "https://hangarcdn.papermc.io/plugins/ViaVersion/ViaVersion/versions/5.0.3/PAPER/ViaVersion-5.0.3.jar";
                hash = "sha256-INTyYb1/VFGB0RHhMLPy4vH9RUXpZju0ZM8nC0DhnXg=";
              };
              ViaBackwards = pkgs.fetchurl {
                url = "https://hangarcdn.papermc.io/plugins/ViaVersion/ViaBackwards/versions/5.0.3/PAPER/ViaBackwards-5.0.3.jar";
                hash = "sha256-L10f9e/ekigNZ/Y4MPD/IjMRk9Zzl+Iuvk+9XWD7nxk=";
              };
              MiniMotd = pkgs.fetchurl {
                url = "https://hangarcdn.papermc.io/plugins/jmp/MiniMOTD/versions/2.1.2/VELOCITY/minimotd-velocity-2.1.2.jar";
                hash = "sha256-MoO4FfbNkeFfywVILeSXDGz17NfsrvqjcDAtn+cK5Cg";
              };
              "minimotd-velocity" = pkgs.linkFarmFromDrvs "minimotd-velocity" (
                builtins.attrValues {
                  "main.conf" = pkgs.writeTextFile {
                    name = "main.conf";
                    text = ''
                      # Enable server list icon related features
                      icon-enabled=true
                      # Enable MOTD-related features
                      motd-enabled=true
                      # The list of MOTDs to display
                      #
                      # - Supported placeholders: <online_players>, <max_players>
                      # - Putting more than one will cause one to be randomly chosen each refresh
                      motds=[
                          {
                              # Set the icon to use with this MOTD
                              #  Either use 'random' to randomly choose an icon, or use the name
                              #  of a file in the icons folder (excluding the '.png' extension)
                              #    ex: icon="myIconFile"
                              icon=random
                              line1="           <#555555>»    <#aa0000>BookyyCorp ❀<#555555> - <#aaaaaa> 1.8.x <#555555>    «"
                              line2="       <#00FF00><bold>Retour </bold><#ffffff>du 1er serveur LG UHC de France"
                          }
                      ]
                      player-count-settings {
                          # Should the displayed online player count be allowed to exceed the displayed maximum player count?
                          # If false, the online player count will be capped at the maximum player count
                          allow-exceeding-maximum=false
                          # Setting this to true will disable the hover text showing online player usernames
                          disable-player-list-hover=false
                          # Settings for the fake player count feature
                          fake-players {
                              # Modes: add, constant, minimum, random, percent
                              #
                              # - add: This many fake players will be added
                              #     ex: fake-players="3"
                              # - constant: A constant value for the player count
                              #     ex: fake-players="=42"
                              # - minimum: The minimum bound of the player count
                              #     ex: fake-players="7+"
                              # - random: A random number of fake players in this range will be added
                              #     ex: fake-players="3:6"
                              # - percent: The player count will be inflated by this much, rounding up
                              #     ex: fake-players="25%"
                              fake-players="15:25"
                              # Enable fake player count feature
                              fake-players-enabled=false
                          }
                          # Setting this to true will disable the player list hover (same as 'disable-player-list-hover'),
                          # but will also cause the player count to appear as '???'
                          hide-player-count=false
                          # Changes the Max Players to be X more than the online players
                          # ex: x=3 -> 16/19 players online.
                          just-x-more-settings {
                              # Enable this feature
                              just-x-more-enabled=false
                              x-value=3
                          }
                          # Changes the Max Players value
                          max-players=300
                          # Enable modification of the max player count
                          max-players-enabled=true
                          # The list of server names that affect player counts/listing.
                          # Only applicable when running the plugin on a proxy (Velocity or Waterfall/Bungeecord).
                          # When set to an empty list, the default count & list as determined by the proxy will be used.
                          servers=[]
                      }
                    '';
                  };
                }
              );
            }
          );
        };
      };
      adventure = {
        enable = true;
        package = pkgs.paperServers.paper-1_21;
        serverProperties = {
          server-port = 25568;
          online-mode = false;
        };
        files = {
          "ops.json".value = [
            {
              name = "Elyth";
              uuid = "aefa1645-766f-479f-a3b3-df636db134c3";
              level = 4;
            }
          ];
          "spigot.yml".value = {
            settings = {
              bungeecord = true;
            };
          };
        };
      };
    };
  };
}
