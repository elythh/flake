{
  config,
  inputs,
  pkgs,
  ...
}:
{
  home = {
    username = "gwen";
    homeDirectory = "/home/gwen";
    stateVersion = "24.05";
    file.".local/share/fonts".source = ./fonts;
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/zsh" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch zsh https://github.com/elythh/dotfiles ${config.home.homeDirectory}/.config/zsh
        fi
      '';
    };

    packages = with pkgs; [
      inputs.zjstatus.packages.${system}.default
      (pkgs.callPackage ../../../home/shared/icons/whitesur.nix { })
      (pkgs.callPackage ../../../home/shared/icons/reversal.nix { })
      awscli
      bemoji
      betterdiscordctl
      bitwarden
      bitwarden-cli
      bore-cli
      bruno
      charm
      charm-freeze
      chatterino2
      chromium
      circumflex
      clipse
      colordiff
      copyq
      deadnix
      delta
      docker-compose
      eza
      feh
      fx
      fzf
      gcc
      gh
      git-absorb
      git-lfs
      gitmoji-cli
      glab
      glow
      gnumake
      go
      google-cloud-sdk
      grimblast
      gum
      helmfile
      hclfmt
      hypnotix
      imagemagick
      inotify-tools
      jaq
      jq
      jqp
      just
      k9s
      keybase
      kubecolor
      kubectl
      kubectx
      kubernetes-helm
      kubie
      lapce
      light
      magic-wormhole
      marksman
      mods
      neovide
      networkmanagerapplet
      nh
      nix-fast-build
      nix-inspect
      nix-output-monitor
      nix-update
      nixfmt-rfc-style
      obsidian
      onefetch
      openssl
      openvpn
      oras
      pavucontrol
      pfetch
      picom
      pinentry
      playerctl
      pre-commit
      presenterm
      python311Packages.gst-python
      python311Packages.pip
      python311Packages.pygobject3
      python311Packages.setuptools
      python311Packages.virtualenv
      qutebrowser
      rcon
      rustup
      satty
      sherlock
      skim
      skopeo
      slides
      sops
      starship
      stern
      syncthing
      t-rec
      tailspin
      (pkgs.callPackage ../../../packages/teams-for-linux { })
      telegram-desktop
      teleport
      tldr
      tuba
      update-nix-fetchgit
      ventoy
      vhs
      viddy
      watershot
      wireplumber
      xdotool
      xwayland
      yarn
      zed-editor
      zellij
      zoxide
    ];
  };
}
