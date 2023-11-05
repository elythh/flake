{ inputs, config, pkgs, lib, nix-colors, spicetify-nix, nixpkgs-f2k, ... }:

let
  hyprland-plugins = inputs.hyprland-plugins;
  split-monitor-workspaces = inputs.split-monitor-workspaces;
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
    #   eww-hyprland = {
    #     enable = true;
    #     package = inputs.eww.packages.${pkgs.system}.eww-wayland;
    #   };
  };

  home.file.".icons/default".source =
    "${pkgs.phinger-cursors}/share/icons/phinger-cursors";
  # gtk themeing
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    iconTheme.name = "WhiteSur";
    theme.name = "phocus";
    font = {
      name = "Lexend";
      size = 11;
    };
  };
  colorScheme =
    {
      colors = import ../shared/cols/sweetpastel.nix { };
      name = "sweetpastel";
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
    ./misc/awesome.nix
    ./misc/betterdiscord.nix
    ./misc/neofetch.nix
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
      (pkgs.callPackage ../shared/icons/whitesur.nix { })
      (pkgs.callPackage ../shared/icons/reversal.nix { })
      zjstatus.packages.${system}.default
      android-tools
      arandr
      awscli
      betterdiscordctl
      bitwarden
      blueberry
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
      armcord
      docker-compose
      dunst
      easyeffects
      eza
      feh
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
      nodePackages.typescript-language-server
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-json-languageserver
      obs-studio
      obsidian
      openvpn
      openssl
      passExtensions.pass-import
      pavucontrol
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
      skim
      slack
      slides
      slurp
      spotify-tui
      spotifyd
      starship
      stern
      syncthing
      telegram-desktop
      rofi-pass
      thunderbird
      tree-sitter
      vault
      wayshot
      xh
      xorg.xrandr
      yarn
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

