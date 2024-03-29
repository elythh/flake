# in home.nix
{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  cfg = config.programs.ags;
  # dependencies required for the ags runtime to function properly
  # some of those dependencies are used internally for setting variables
  # or basic functionality where built-in services do not suffice
  coreDeps = with pkgs; [
    inputs.hyprpicker.packages.${pkgs.system}.default
    inputs.hyprland.packages.${pkgs.system}.default

    # basic functionality
    inotify-tools
    gtk3

    # script and service helpers
    bash
    coreutils
    gawk
    procps
    ripgrep
    brightnessctl
    libnotify
    slurp
    sysstat
    sassc
    (python3.withPackages (ps: [ps.requests]))
  ];

  # applications that are not necessarily required to compile ags
  # but are used by the widgets to launch certain applications
  widgetDeps = with pkgs; [
    pavucontrol
    networkmanagerapplet
    blueman
  ];
  dependencies = coreDeps ++ widgetDeps;
in
  with config.colorscheme.palette; {
    imports = [inputs.ags.homeManagerModules.default];
    config = lib.mkIf (config.default.bar == "ags") {
      home.file.".config/ags/style/colors.scss".text = ''
        $primary : #${background};
        $onPrimary : #${foreground};
        $secondary : #${mbg};
        $onSecondary : #${color7};
        $surface : #${darker};
        $onSurface : #${foreground};
        $surfaceVariant: #${mbg};
        $onSurfaceVariant: #${color7};
        $shadow: #000;

        $red : #${color1};
        $green : #${color2};
        $yellow : #${color3};
        $blue : #${color4};
        $lavender : #${color13};
      '';

      programs.ags = {
        enable = true;
        # packages to add to gjs's runtime
        extraPackages = [pkgs.libsoup_3];
      };

      systemd.user.services.ags = {
        Install.WantedBy = ["graphical-session.target"];

        Unit = {
          Description = "Aylur's Gtk Shell (Ags)";
          After = ["graphical-session-pre.target"];
          PartOf = [
            "tray.target"
            "graphical-session.target"
          ];
        };

        Service = {
          Type = "simple";

          Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
          ExecStart = "${cfg.package}/bin/ags";
          ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID"; # hot-reloading

          # runtime
          RuntimeDirectory = "ags";
          ProtectSystem = "strict";
          ProtectHome = "read-only";
          CacheDirectory = ["ags"];
          ReadWritePaths = [
            # /run/user/1000 for the socket
            "%t"
            "/tmp/hypr"
          ];

          # restart on failure
          Restart = "on-failure";
          KillMode = "mixed";
        };
      };
    };
  }
