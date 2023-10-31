{ inputs, config, pkgs, lib, ... }:

let
  spicetify-nix = inputs.spicetify-nix;
  colors = import ../shared/cols/cat.nix { };
  hyprland = inputs.hyprland;
  hyprland-plugins = inputs.hyprland-plugins;
  split-monitor-workspaces = inputs.split-monitor-workspaces;
  zjstatus = inputs.zjstatus;
  anyrun = inputs.anyrun;
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
  imports = [
    # Importing Configurations
    # (import ./conf/ui/eww/default.nix { inherit pkgs inputs config lib colors; })
    (import ../shared/xresources.nix { inherit colors; })
    (import ./conf/music/cava/default.nix { inherit colors; })
    (import ./conf/music/spicetify/default.nix { inherit colors spicetify-nix pkgs; })
    (import ./conf/shell/zsh/default.nix { inherit config colors pkgs; })
    (import ./conf/utils/swayidle/default.nix { inherit pkgs; })
    (import ./conf/term/kitty/default.nix { inherit pkgs colors; })
    (import ./conf/term/wezterm/default.nix { inherit pkgs colors; })
    (import ./conf/term/zellij { inherit pkgs colors; })
    (import ./conf/ui/hyprland/default.nix { inherit inputs pkgs colors; })
    (import ./conf/ui/ags/default.nix { inherit inputs pkgs; })
    (import ./conf/utils/dunst/default.nix { inherit colors pkgs; })
    (import ./conf/utils/gpg-agent/default.nix { inherit pkgs; })
    (import ./conf/utils/lf/default.nix { inherit inputs pkgs; })
    (import ./conf/utils/k9s/default.nix { inherit config colors pkgs; })
    (import ./conf/utils/rofi/default.nix { inherit config pkgs colors; })
    (import ./conf/utils/spotifyd/default.nix { inherit pkgs; })
    (import ./conf/utils/swaylock/default.nix { inherit colors pkgs; })
    (import ./misc/betterdiscord.nix { inherit config colors; })
    (import ./misc/neofetch.nix { inherit config colors; })
    (import ./misc/xinit.nix { })
    # Bin files
    (import ../shared/bin/default.nix { inherit config colors; })
    (import ../shared/lock.nix { inherit colors; })
  ];
  home = {
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/elythh/nvim ${config.home.homeDirectory}/.config/nvim
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/zsh" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch zsh https://github.com/elythh/dotfiles ${config.home.homeDirectory}/.config/zsh
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/hypr" ]; then
         ln -s "/etc/nixos/config/hypr/" "${config.home.homeDirectory}/.config/hypr"
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/wlogout" ]; then
         ln -s "/etc/nixos/config/wlogout/" "${config.home.homeDirectory}/.config/wlogout"
        fi
      '';
    };
    packages = with pkgs; [
      (pkgs.callPackage ../../derivs/phocus.nix { inherit colors; })
      (pkgs.callPackage ../shared/icons/whitesur.nix { })
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
      emote
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
      gnome.gnome-calendar
      gnome.gnome-boxes
      gnome.gnome-system-monitor
      gnome.gnome-control-center
      gnome.gnome-weather
      gnome.gnome-calculator
      gnome.gnome-software
      go
      gojq
      google-cloud-sdk
      graphite-gtk-theme
      gsettings-desktop-schemas
      helmfile
      hyprland-autoname-workspaces
      hyprpicker
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
      sassc
      slack
      slides
      slurp
      spotify-tui
      spotifyd
      starship
      stern
      swappy
      swww
      syncthing
      telegram-desktop
      tessen
      thunderbird
      tree-sitter
      vault
      wayshot
      wf-recorder
      wl-clipboard
      wlogout
      wlr-randr
      xdg-desktop-portal-hyprland
      xh
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

