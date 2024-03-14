{
  pkgs,
  inputs,
  config,
  ...
}: {
  # gtk themeing
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    iconTheme.name = "Reversal-dark";
    theme.name = "phocus";
    font = {
      name = "Lexend";
      size = 11;
    };
  };

  wallpaper = /etc/nixos/home/shared/walls/${config.theme}.jpg;
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  home = {
    username = "gwen";
    homeDirectory = "/home/gwen";
    stateVersion = "23.11";
    file.".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors";
    file.".local/share/fonts".source = ../../gwen/fonts;
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
      (pkgs.callPackage ../../shared/icons/whitesur.nix {})
      (pkgs.callPackage ../../shared/icons/reversal.nix {})
      alejandra
      awscli
      betterdiscordctl
      bitwarden
      chatterino2
      charm
      chromium
      colordiff
      commitizen
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
      go
      google-cloud-sdk
      gum
      helmfile
      imagemagick
      inotify-tools
      jaq
      jellyfin-media-player
      jq
      jqp
      just
      k9s
      krew
      kubecolor
      kubectl
      kubectx
      kubernetes-helm
      kubie
      lazygit
      light
      logseq
      maim
      marksman
      mods
      morgen
      neovide
      networkmanagerapplet
      niv
      nix-index
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-json-languageserver
      obsidian
      ollama
      onefetch
      openssl
      openvpn
      papirus-icon-theme
      pass
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
      rbw
      rcon
      rofi-rbw
      rustup
      satty
      scrcpy
      skate
      skim
      slack
      slides
      screenkey
      starship
      stern
      stremio
      syncthing
      t-rec
      teeworlds
      tailspin
      telegram-desktop
      tldr
      tmate
      tree-sitter
      vault
      viddy
      wireplumber
      yarn
      zellij
      zoxide
    ];
  };

  programs.home-manager.enable = true;
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    bash.enable = true;
  };

  nixpkgs.overlays = [
    inputs.nur.overlay
    inputs.nixpkgs-wayland.overlay
    (final: prev: {
      # Fix slack screen sharing following: https://github.com/flathub/com.slack.Slack/issues/101#issuecomment-1807073763
      slack = prev.slack.overrideAttrs (previousAttrs: {
        installPhase =
          previousAttrs.installPhase
          + ''
            sed -i'.backup' -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

          '';
      });
    })
  ];
  nixpkgs.config = {
    permittedInsecurePackages = ["electron-25.9.0"];
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };
}
