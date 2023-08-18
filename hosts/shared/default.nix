{ pkgs, outputs, overlays, lib, inputs, ... }:
let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  my-python-packages = ps: with ps; [
    numpy
  ];
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  programs.zsh.enable = true;

  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };
  security = {
    sudo.enable = true;
  };
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
  services.blueman = {
    enable = true;
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
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "libvirtd" "docker" ];
      packages = with pkgs; [ ];
    };
    defaultUserShell = pkgs.zsh;
  };
  fonts.packages = with pkgs; [
    material-design-icons
    # phospor
    inter
    material-symbols
    rubik
    ibm-plex
    (nerdfonts.override { fonts = [ "Iosevka" "CascadiaCode" "JetBrainsMono" ]; })
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
  security.rtkit.enable = true;
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    (pkgs.python3.withPackages my-python-packages)
    armcord
    bat
    blueman
    brightnessctl
    brillo
    firefox
    git
    gtk3
    home-manager
    imgclr
    inotify-tools
    jq
    keybase
    kaiteki
    libnotify
    lua-language-server
    lua54Packages.lua
    lutgen
    maim
    mpv
    nix-prefetch-git
    nodejs
    pamixer
    pstree
    pulseaudio
    python3
    ripgrep
    rnix-lsp
    simplescreenrecorder
    slop
    spotdl
    spotify
    st
    tailscale
    terraform
    terraform-ls
    udiskie
    grim
    slop
    inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    eww-wayland
    wayland
    swaylock-effects
    swaybg
    ueberzugpp
    unzip
    wirelesstools
    wmctrl
    xclip
    xdg-utils
    xdotool
    xorg.xf86inputevdev
    xorg.xf86inputlibinput
    xorg.xf86inputsynaptics
    xorg.xf86videoati
    xorg.xorgserver
    xorg.xwininfo
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
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
  services.printing.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.xserver = {
    layout = "fr";
    xkbVariant = "fr,";
  };
  services.tailscale = {
    enable = true;
  };
  services.mullvad-vpn.enable = true;
  services.keybase = {
    enable = true;
  };
  services.arbtt.enable = true;
  security.polkit.enable = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
    optimise.automatic = true;
  };
  system = {
    copySystemConfiguration = false;
  };
}
