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
    stateVersion = "23.11";
    file.".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors";
    file.".local/share/fonts".source = ./fonts;
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/zsh" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch zsh https://github.com/elythh/dotfiles ${config.home.homeDirectory}/.config/zsh
        fi
      '';
    };

    packages = with pkgs; [
      inputs.nixvim.packages.${system}.default
      inputs.zjstatus.packages.${system}.default
      (pkgs.callPackage ../../../derivs/spotdl.nix {
        inherit (pkgs.python311Packages) buildPythonApplication;
      })
      (pkgs.callPackage ../../../home/shared/icons/whitesur.nix {})
      (pkgs.callPackage ../../../home/shared/icons/reversal.nix {})
      alejandra
      auth0-cli
      awscli
      betterdiscordctl
      bitwarden
      bitwarden-cli
      chatterino2
      charm-freeze
      charm
      chromium
      clipse
      colordiff
      copyq
      circumflex
      docker-compose
      easyeffects
      eza
      feh
      fx
      fzf
      gcc
      gh
      git-lfs
      gitmoji-cli
      glow
      gnumake
      pkgsStable.go
      google-cloud-sdk
      gum
      helmfile
      imagemagick
      inotify-tools
      jaq
      jq
      jqp
      just
      k9s
      kubecolor
      kubectl
      kubectx
      kubernetes-helm
      kubie
      light
      marksman
      networkmanagerapplet
      obsidian
      onefetch
      openssl
      openvpn
      pavucontrol
      pfetch
      pinentry
      playerctl
      presenterm
      python311Packages.gst-python
      python311Packages.pip
      python311Packages.pygobject3
      python311Packages.setuptools
      python311Packages.virtualenv
      (lib.mkIf config.modules.rbw.enable rbw)
      rcon
      (lib.mkIf config.modules.rbw.enable rofi-rbw)
      rustup
      satty
      sherlock
      skim
      slack
      slides
      starship
      stern
      tailspin
      telegram-desktop
      tldr
      viddy
      wireplumber
      yarn
      zellij
      zoxide
    ];
  };
}
