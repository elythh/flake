{ inputs, config, pkgs, lib, ... }:

let
  spicetify-nix = inputs.spicetify-nix;
  colors = import ../shared/cols/cat.nix { };
  hyprland = inputs.hyprland;
  hyprland-plugins = inputs.hyprland-plugins;
  unstable = import
    (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/master.tar.gz")
    {
      config = config.nixpkgs.config;
    };
  nixpkgs-f2k = inputs.nixpkgs-f2k;
in
{
  # some general info
  home.username = "gwen";
  home.homeDirectory = "/home/gwen";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.file.".icons/default".source =
    "${pkgs.phinger-cursors}/share/icons/phinger-cursors";


  # gtk themeing
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    iconTheme.name = "WhiteSur";
    theme.name = "phocus";
  };
  nixpkgs.overlays = [
  ];
  imports = [
    # Importing Configurations
    (import ../shared/xresources.nix { inherit colors; })
    (import ./conf/utils/rofi/default.nix { inherit config pkgs colors; })
    (import ./conf/utils/dunst/default.nix { inherit colors pkgs; })
    (import ./conf/music/cava/default.nix { inherit colors; })
    (import ./conf/shell/zsh/default.nix { inherit config colors pkgs; })
    (import ./conf/utils/k9s/default.nix { inherit config colors pkgs; })
    (import ./conf/utils/keybase/default.nix { inherit pkgs; })
    (import ./conf/term/kitty/default.nix { inherit pkgs colors; })
    (import ./conf/term/wezterm/default.nix { inherit pkgs colors; })
    (import ./conf/editors/vscopium/default.nix { })
    (import ./conf/music/spicetify/default.nix { inherit colors spicetify-nix pkgs; })
    (import ./conf/utils/sxhkd/default.nix { })
    (import ./conf/music/mpd/default.nix { inherit config pkgs; })
    (import ./conf/music/ncmp/default.nix { inherit config pkgs; })
    (import ./misc/awesome.nix { inherit pkgs colors; })
    (import ./misc/neofetch.nix { inherit config colors; })
    (import ./conf/ui/hyprland/default.nix { inherit config pkgs lib hyprland hyprland-plugins colors; })
    (import ./conf/ui/waybar/default.nix { inherit config pkgs lib hyprland colors; })
    (import ./conf/utils/swaylock/default.nix { inherit colors pkgs; })
    (import ./misc/xinit.nix { })
    (import ./misc/eww.nix { inherit config colors; })
    (import ./conf/term/zellij { inherit pkgs colors; })
    # Bin files
    (import ../shared/bin/default.nix { inherit config colors; })
    (import ../shared/lock.nix { inherit colors; })
  ];
  home = {
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch awesome https://github.com/elythh/dotfiles ${config.home.homeDirectory}/.config/awesome
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/eww" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch eww https://github.com/elythh/dotfiles ${config.home.homeDirectory}/.config/eww
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
      (pkgs.callPackage ../../derivs/phocus.nix { inherit colors; })
      (pkgs.callPackage ../shared/icons/whitesur.nix { })
      activitywatch
      android-tools
      arandr
      awscli
      bc
      bitwarden
      btop
      catimg
      cava
      chatterino2
      chromium
      cinnamon.nemo
      colordiff
      nodePackages.vscode-css-languageserver-bin
      docker-compose
      dunst
      exa
      feh
      ffmpeg_5-full
      flyctl
      fzf
      gcc
      glow
      gnumake
      gnupg
      go
      google-cloud-sdk
      haskellPackages.arbtt
      hsetroot
      i3lock-fancy
      imagemagick
      jellyfin-media-player
      jqp
      k9s
      killall
      krew
      kubecolor
      kubectl-tree
      kubectx
      kubernetes-helm
      lazygit
      mullvad
      mpc-cli
      mpdris2
      neofetch
      neovim
      networkmanagerapplet
      nodePackages.typescript-language-server
      nodePackages.vscode-json-languageserver
      obsidian
      openvpn
      pavucontrol
      pfetch
      playerctl
      procps
      python310Packages.pip
      python310Packages.setuptools
      python310Packages.virtualenv
      recode
      ripgrep
      rustup
      slack
      slurp
      socat
      starship
      stern
      syncthing
      thunderbird
      tree-sitter
      vault
      moreutils
      virtualenv
      sway-contrib.grimshot
      wl-clipboard
      xdg-desktop-portal-hyprland
      xh
      xorg.xev
      xss-lock
      yq
      zellij
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };
  home.sessionVariables = {
    WALLPAPER = "${config.home.homeDirectory}/.config/awesome/theme/wallpapers/${colors.name}/${colors.wallpaper}";
  };
}

