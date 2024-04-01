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
        $base00: #${background};
        $base01: #${mbg};
        $base02: #${darker};
        $base03: #${color4};
        $base04: #${color5};
        $base05: #${foreground};
        $base06: #${color7};
        $base07: #${color8};
        $base08: #${color9};
        $base09: #${color10};
        $base0A: #${accent};
        $base0B: #${color12};
        $base0C: #${color13};
        $base0D: #${color14};
        $base0E: #${color15};
        $base0F: #${accent};
      '';

      programs.ags = {
        enable = true;
        # packages to add to gjs's runtime
        extraPackages = [pkgs.libsoup_3];
      };
    };
  }
