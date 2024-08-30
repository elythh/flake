{
  config,
  inputs,
  lib,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (lib)
    makeBinPath
    mkIf
    types
    ;
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled;
  inherit (inputs) hyprland;

  cfg = config.${namespace}.programs.graphical.wms.hyprland;

  programs = makeBinPath (
    with pkgs;
    [
      # TODO: make sure this references same package as home-manager
      hyprland.packages.${system}.hyprland
      coreutils
      config.services.power-profiles-daemon.package
      systemd
      libnotify
    ]
  );
in
{
  options.${namespace}.programs.graphical.wms.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
    customConfigFiles =
      mkOpt attrs { }
        "Custom configuration files that can be used to override the default files.";
    customFiles = mkOpt attrs { } "Custom files that can be used to override the default files.";
    wallpaper = mkOpt (nullOr package) null "The wallpaper to display.";
  };

  disabledModules = [ "programs/hyprland.nix" ];

  config = mkIf cfg.enable {
    environment = {
      etc."greetd/environments".text = ''
        "Hyprland"
        zsh
      '';
    };

    elyth = {
      display-managers = {
        sddm = {
          enable = true;
        };
      };

      home = {
        configFile = cfg.customConfigFiles;
        file = { } // cfg.customFiles;
      };

      programs = {
        graphical = {
          apps = {
            partitionmanager = enabled;
          };

          addons = {
            keyring = enabled;
            xdg-portal = enabled;
          };

          file-managers = {
            thunar = enabled;
          };
        };
      };

      security = {
        keyring = enabled;
        polkit = enabled;
      };

      suites = {
        wlroots = enabled;
      };
    };

    services.displayManager.sessionPackages = [ hyprland.packages.${system}.hyprland ];
  };
}
