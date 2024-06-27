{
  config,
  inputs,
  lib,
  pkgs,
  pkgsStable,
  ...
}: {
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
      (pkgs.callPackage ../../../home/shared/icons/whitesur.nix {})
      (pkgs.callPackage ../../../home/shared/icons/reversal.nix {})
      (lib.mkIf config.modules.rbw.enable rbw)
      (lib.mkIf config.modules.rbw.enable rofi-rbw)
      alejandra
      auth0-cli
      awscli
      bemoji
      betterdiscordctl
      bitwarden
      bitwarden-cli
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
      docker-compose
      easyeffects
      eza
      feh
      floorp
      fx
      fzf
      gcc
      gh
      git-lfs
      gitmoji-cli
      glab
      glow
      gnumake
      google-cloud-sdk
      grimblast
      gum
      helmfile
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
      light
      lunar-client
      marksman
      networkmanagerapplet
      nh
      nix-inspect
      neovide
      obsidian
      onefetch
      openssl
      openvpn
      pavucontrol
      pfetch
      picom
      pinentry
      pkgsStable.go
      playerctl
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
      skopeo
      oras
      skim
      slack
      slides
      starship
      stern
      syncthing
      tailspin
      teams-for-linux
      telegram-desktop
      teleport
      tldr
      ventoy
      viddy
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
