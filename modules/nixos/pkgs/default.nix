{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfgTailscale = config.meadow.programs.tailscale;
  cfgWayland = config.meadow.programs.wayland;
in
{
  options.meadow.programs = {
    tailscale.enable = mkEnableOption "tailscale";
    wayland.enable = mkEnableOption "wayland";
  };

  config = {
    system.activationScripts.diff = {
      text = ''
        if [[ -e /run/current-system ]]; then
          echo "=== diff to current-system ==="
          ${lib.getExe pkgs.lix-diff} --lix-bin ${config.nix.package}/bin /run/current-system "$systemConfig"
          echo "=== end of the system diff ==="
        fi
      '';
    };
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
      lix-diff
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
      (mkIf cfgTailscale.enable tailscale)
      unzip
      (mkIf cfgWayland.enable wayland)
      wget
      wirelesstools
      xdg-utils
      yaml-language-server
      yq
    ];
  };
}
