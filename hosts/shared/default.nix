{ pkgs, outputs, config, overlays, lib, inputs, ... }:
let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  my-python-packages = ps: with ps; [
    numpy
    material-color-utilities
  ];
in
{
  nixpkgs.overlays = [
    (self: super: {
      gg-sans = super.callPackage ../../derivs/gg-sans { };
    })
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  programs.zsh.enable = true;

  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Europe/Paris";
  };
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
  users = {
    users.gwen = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "libvirtd" "docker" "vboxusers" ];
    };
    defaultUserShell = pkgs.zsh;
  };
  fonts.packages = with pkgs; [
    rubik
    gg-sans
    lexend
    # icon fonts
    material-design-icons

    # normal fonts
    lexend
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    roboto

    # nerdfonts
    (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "JetBrainsMono" ]; })
  ];
  sound.enable = true;
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };
  environment.systemPackages = with pkgs; [
    (pkgs.python3.withPackages my-python-packages)
    age
    bat
    blueman
    brightnessctl
    dosis
    librewolf
    git
    gtk3
    home-manager
    lua-language-server
    lua54Packages.lua
    mpv
    nix-prefetch-git
    nodejs
    pamixer
    pulseaudio
    python3
    ripgrep
    rnix-lsp
    simplescreenrecorder
    slop
    spotify
    st
    tailscale
    terraform-docs
    terraform-ls
    grim
    slop
    wayland
    swaylock-effects
    swaybg
    unzip
    wirelesstools
    yaml-language-server
  ];

  environment.shells = with pkgs; [ zsh ];

  programs.dconf.enable = true;
  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };
  services.dbus.enable = true;
  programs.sway = {
    enable = true;
  };
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  security = {
    pam.services = {
      greetd = {
        gnupg.enable = true;
        enableGnomeKeyring = true;
      };

      login = {
        enableGnomeKeyring = true;
        gnupg = {
          enable = true;
          noAutostart = true;
          storeOnly = true;
        };
      };

      swaylock.text = "auth include login";
    };

    polkit.enable = true;
  };


  services = {
    gnome = {
      gnome-keyring.enable = true;
      glib-networking.enable = true;
    };

    greetd = {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session =
          let
            base = config.services.xserver.displayManager.sessionData.desktops;
          in
          {
            command = lib.concatStringsSep " " [
              (lib.getExe pkgs.greetd.tuigreet)
              "--time"
              "--remember"
              "--remember-user-session"
              "--asterisks"
              "--sessions '${base}/share/wayland-sessions:${base}/share/xsessions'"
            ];
            user = "greeter";
          };
      };
    };
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
    };
  };

  services.blueman.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "";
    xkbOptions = "compose:rctrl,caps:escape";
  };
  services.tailscale = {
    enable = true;
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 1d";
    };
    optimise.automatic = true;
  };
  system = {
    copySystemConfiguration = false;
  };
}
