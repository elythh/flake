{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    sops

    age
    bat
    blueman
    btop
    brightnessctl
    dig
    dosis
    ffmpeg_7-full
    git
    git-extras
    gnu-config
    gnupg
    grim
    gtk3
    home-manager
    kanata
    lua-language-server
    lua54Packages.lua
    mpv
    ncdu
    nix-prefetch-git
    nodejs
    obs-studio
    pamixer
    procps
    pulseaudio
    python3
    ripgrep
    sd
    slack
    slack-term
    slop
    spotify
    srt
    (lib.mkIf config.tailscale.enable tailscale)
    terraform-ls
    unzip
    (lib.mkIf config.wayland.enable wayland)
    wget
    wirelesstools
    xdg-utils
    yaml-language-server
    yq
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };
}
