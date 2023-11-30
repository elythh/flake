{ inputs, config, pkgs, lib, nix-colors, spicetify-nix, polymc, nixpkgs-f2k, ... }:

let
  theme = "kizu";
  hyprland-plugins = inputs.hyprland-plugins;
  zjstatus = inputs.zjstatus;
  anyrun = inputs.anyrun;
  unstable = import
    (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/master.tar.gz")
    {
      config = config.nixpkgs.config;
    };
in
{
  # some general info
  home.username = "gwen";
  home.homeDirectory = "/home/gwen";
  home.stateVersion = "23.05";
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

  # The global colorScheme, used by most apps
  colorScheme =
    {
      colors = import ../shared/cols/${theme}.nix { };
      name = "${theme}";
    };

  imports = [
    #import ./conf/ui/hyprland/default.nix

    nix-colors.homeManagerModules.default
    # Importing Configurations
    ./conf/music/cava
    ./conf/music/spicetify
    ./conf/shell/zsh
    ./conf/term/kitty/default.nix
    ./conf/term/wezterm/default.nix
    ./conf/term/zellij
    ./conf/utils/dunst/default.nix
    ./conf/utils/gpg-agent/default.nix
    ./conf/utils/k9s/default.nix
    ./conf/utils/lf/default.nix
    ./conf/utils/picom
    ./conf/utils/rofi/default.nix
    ./conf/utils/spotifyd/default.nix
    ./misc/betterdiscord.nix
    ./misc/neofetch.nix
    ./misc/vencord.nix
    ./misc/xinit.nix
    # Bin files
    ../shared/bin/default.nix
    ../shared/lock.nix
  ];
  home = {
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch alps https://github.com/chadcat7/crystal ${config.home.homeDirectory}/.config/awesome
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/elythh/nvim ${config.home.homeDirectory}/.config/nvim
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/zsh" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch zsh https://github.com/elythh/dotfiles ${config.home.homeDirectory}/.config/zsh
        fi
      '';
    };
    packages = with pkgs; [
      (pkgs.callPackage ../../derivs/phocus.nix { inherit config nix-colors; })
      (pkgs.callPackage ../../derivs/gruv.nix { })
      (pkgs.callPackage ../shared/icons/whitesur.nix { })
      (pkgs.callPackage ../shared/icons/reversal.nix { })
      zjstatus.packages.${system}.default
      android-tools
      arandr
      awscli
      betterdiscordctl
      bitwarden
      blueberry
      bluez
      bluez-tools
      bluez-alsa
      btop
      brave
      cava
      chatterino2
      chromium
      cinnamon.nemo
      cinnamon.nemo-fileroller
      clight
      colordiff
      dig
      docker-compose
      dunst
      easyeffects
      eza
      feh
      ferium
      ffmpeg_5-full
      fzf
      gcc
      git-lfs
      glib
      glow
      gnumake
      gnupg
      go
      gojq
      google-cloud-sdk
      graphite-gtk-theme
      gsettings-desktop-schemas
      helmfile
      hicolor-icon-theme
      hyprland-autoname-workspaces
      hyprpicker
      i3lock-fancy
      jellyfin-media-player
      jqp
      jq
      just
      k9s
      krew
      kubecolor
      kubectl
      kubectl-tree
      kubectx
      kubernetes-helm
      lazygit
      light
      lxappearance-gtk2
      maim
      mullvad-vpn
      ncdu
      neofetch
      neovim
      networkmanagerapplet
      niv
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-json-languageserver
      ollama
      obs-studio
      obsidian
      openvpn
      openssl
      passExtensions.pass-import
      pavucontrol
      pass
      pfetch
      pinentry
      playerctl
      procps
      python311Packages.pip
      python311Packages.gst-python
      python311Packages.pygobject3
      python311Packages.setuptools
      python311Packages.virtualenv
      ripgrep
      rustup
      scrcpy
      skim
      slack
      slides
      slurp
      spotify-tui
      spotifyd
      starship
      stern
      stremio
      syncthing
      telegram-desktop
      rofi-pass
      thunderbird
      tree-sitter
      vault
      (discord.override {
        withVencord = true;
      })
      webcord-vencord
      wayshot
      wget
      xh
      xss-lock
      xcolor
      xorg.xrandr
      yarn
      yazi
      yq
      zellij
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };
}

