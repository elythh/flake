{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.fish.enable = true;
  programs.git.enable = true;

  home = {
    username = "elyth";
    homeDirectory = lib.mkForce "/Users/elyth";
    stateVersion = "25.11";

    packages = with pkgs; [
      inputs.zen-browser.packages.${system}.default
      inputs.neovim.packages.${system}.default

      asciinema_3
      bitwarden
      bore-cli
      bruno
      charm
      charm-freeze
      circumflex
      clipse
      colordiff
      deadnix
      delta
      docker-compose
      doggo
      eza
      fd
      feh
      fx
      fzf
      gcc
      gh
      git-absorb
      gitmoji-cli
      glab
      glow
      gnumake
      go
      gping
      gum
      helmfile
      httpie
      imagemagick
      jq
      jqp
      just
      k9s
      keybase
      kubecolor
      kubectl
      kubectx
      kubernetes-helm
      lazygit
      magic-wormhole
      mods
      navi
      nh
      nix-fast-build
      nix-inspect
      nix-output-monitor
      nix-search-tv
      nix-update
      nixfmt-rfc-style
      obsidian
      onefetch
      opencode
      openssl
      openvpn
      opkssh
      pfetch
      pgcli
      pre-commit
      presenterm
      python312Packages.gst-python
      python312Packages.materialyoucolor
      python312Packages.pillow
      python312Packages.pip
      python312Packages.pygobject3
      python312Packages.setuptools
      python312Packages.virtualenv
      slides
      sops
      starship
      stern
      syncthing
      telegram-desktop
      television
      tldr
      up
      vegeta
      viddy
    ];
  };
}
