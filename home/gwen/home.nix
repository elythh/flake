{ inputs, config, pkgs, ... }: {
  # some general info
  theme = "rose";
  home.username = "gwen";
  home.homeDirectory = "/home/gwen";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    bash.enable = true; # see note on other shells below
  };

  home.file.".icons/default".source =
    "${pkgs.phinger-cursors}/share/icons/phinger-cursors";
  home.file.".local/share/fonts".source = ./fonts;

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

  # The global colorScheme, used by most apps
  colorScheme = {
    palette = import ../shared/cols/${config.theme}.nix { };
    name = "${config.theme}";
  };

  home.sessionVariables.EDITOR = "nvim";

  imports = [
    ./options.nix
    ./misc/ewwags.nix
    ./misc/obsidian.nix
    ./conf/ui/ags
    # ./conf/ui/wayland/swayfx
    ./conf/ui/wayland/hyprland
    ./conf/utils/swaync

    inputs.nix-colors.homeManagerModules.default
    inputs.anyrun.homeManagerModules.default
    # Importing Configurations
    # ./conf/music/mpd
    # ./conf/music/ncmp/hypr.nix
    ./conf/music/spicetify
    ./conf/shell/zsh
    ./conf/term/kitty
    #./conf/term/wezterm
    ./conf/term/zellij
    ./conf/utils/firefox
    ./conf/utils/gpg-agent
    ./conf/utils/k9s
    ./conf/utils/lazygit
    ./conf/utils/lf
    ./conf/utils/rofi
    #./conf/utils/sss
    ./conf/utils/gitui
    ./misc/neofetch.nix
    ./misc/vencord.nix
    # Bin files
    ../shared/bin/default.nix
  ];
  home = {
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/zsh" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch zsh https://github.com/elythh/dotfiles ${config.home.homeDirectory}/.config/zsh
        fi
      '';
    };
    packages = with pkgs; [
      (pkgs.callPackage ../../derivs/phocus.nix { inherit config nix-colors; })
      (pkgs.callPackage ../../derivs/discordo.nix { })
      (pkgs.callPackage ../../derivs/spotdl.nix {
        inherit (pkgs.python311Packages) buildPythonApplication;
      })
      (pkgs.callPackage ../shared/icons/whitesur.nix { })
      (pkgs.callPackage ../shared/icons/reversal.nix { })
      (discord.override { withVencord = true; })
      inputs.zjstatus.packages.${system}.default
      inputs.nixvim.packages.${system}.default
      # neovim
      android-tools
      awscli
      betterdiscordctl
      bitwarden
      cava
      chafa
      chatterino2
      chromium
      colordiff
      commitizen
      copyq
      circumflex
      dijo
      dmenu
      docker-compose
      easyeffects
      eza
      feh
      fff
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
      skim
      slack
      slides
      screenkey
      starship
      stern
      stremio
      syncthing
      tailspin
      t-rec
      telegram-desktop
      tmate
      tree-sitter
      vault
      viddy
      wireplumber
      yarn
      yazi
      zellij
      zoxide
    ];
  };

  nixpkgs.overlays = [
    inputs.nur.overlay
    inputs.nixpkgs-wayland.overlay
    (final: prev: {
      # Fix slack screen sharing following: https://github.com/flathub/com.slack.Slack/issues/101#issuecomment-1807073763
      slack = prev.slack.overrideAttrs (previousAttrs: {
        installPhase = previousAttrs.installPhase + ''
          sed -i'.backup' -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

        '';
      });
    })

  ];

  nixpkgs.config = {
    permittedInsecurePackages = [ "electron-25.9.0" ];
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };
}
