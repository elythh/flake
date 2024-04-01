{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    age
    bat
    blueman
    btop
    brightnessctl
    dig
    dosis
    ffmpeg_5-full
    git
    gnu-config
    gnupg
    grim
    gtk3
    home-manager
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
    slop
    spotify
    srt
    (lib.mkIf config.tailscale.enable tailscale)
    terraform-ls
    unzip
    (lib.mkIf config.wayland.enable wayland)
    wget
    wirelesstools
    yaml-language-server
    yq
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };
}
