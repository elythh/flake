{ config
, pkgs
, lib
, inputs
, colors
, ...
}:
let
  dependencies = with pkgs; [
    cfg.package

    inputs.gross.packages.${pkgs.system}.gross
    config.wayland.windowManager.hyprland.package

    bash
    blueberry
    bluez
    brillo
    coreutils
    dbus
    findutils
    gawk
    gnome.gnome-control-center
    gnused
    imagemagick
    jaq
    jc
    libnotify
    networkmanager
    pavucontrol
    playerctl
    procps
    pulseaudio
    ripgrep
    socat
    udev
    upower
    util-linux
    wget
    wireplumber
    wlogout
  ];

  reload_script = pkgs.writeShellScript "reload_eww" ''
    windows=$(eww windows | rg '\*' | tr -d '*')

    systemctl --user restart eww.service

    echo $windows | while read -r w; do
      eww open $w
    done
  '';

  cfg = config.programs.eww-hyprland;
in
{
  options.programs.eww-hyprland = {
    enable = lib.mkEnableOption "eww Hyprland config";

    package = lib.mkOption {
      type = with lib.types; nullOr package;
      default = pkgs.eww-wayland;
      defaultText = lib.literalExpression "pkgs.eww-wayland";
      description = "Eww package to use.";
    };

    autoReload = lib.mkOption {
      type = lib.types.bool;
      default = false;
      defaultText = lib.literalExpression "false";
      description = "Whether to restart the eww daemon and windows on change.";
    };

    colors = lib.mkOption {
      type = with lib.types; nullOr lines;
      default = null;
      defaultText = lib.literalExpression "null";
      description = ''
        SCSS file with colors (defaults to dark mode).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # remove nix files
    xdg.configFile."eww" = {
      source = lib.cleanSourceWith {
        filter = name: _type:
          let
            baseName = baseNameOf (toString name);
          in
          !(lib.hasSuffix ".nix" baseName) && (baseName != "colors-dark.scss") && (baseName != "colors-light.scss");
        src = lib.cleanSource ./.;
      };

      # links each file individually, which lets us insert the colors file separately
      recursive = true;

      onChange =
        if cfg.autoReload
        then reload_script.outPath
        else "";
    };

    # colors file
    xdg.configFile."eww/css/colors.scss".text =
      ''


    $red: #${colors.color1};
    $yellow: #${colors.color3};
    $green: #${colors.color2};
    $blue: #${colors.color4};
    
    $tooltip-bg: #${colors.darker};
    
    $accent: #${colors.color4};
    
    $bar-bg: rgba(0, 0, 0, 0.2);
    $bg: #${colors.background};
    $fg: #${colors.foreground};
    $surface: #${colors.mbg};
    $overlay: #${colors.comment};
    
    $button: $surface;
    $hover: adjust_color($button, $alpha: +0.1);
    
    $button-active: $accent;
    $button-active-hover: adjust_color($accent, $lightness: +20%);
    
    $text: $fg;
    $subtext: #${colors.comment};
    
    $focused: $bg;
    
    * {
      text-shadow: 0 2px 3px rgba(0, 0, 0, 0.2);
    }
    
    @mixin border {
      box-shadow:
        inset 0 0 0 1px rgba(255, 255, 255, 0.1),
        0 0 0 1px rgba(0, 0, 0, 0.5);
    }
      '';
    systemd.user.services.eww = {
      Unit = {
        Description = "Eww Daemon";
        # not yet implemented
        # PartOf = ["tray.target"];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${cfg.package}/bin/eww daemon --no-daemonize";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
