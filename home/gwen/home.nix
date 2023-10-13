{ inputs, config, pkgs, lib, ... }:

let
  spicetify-nix = inputs.spicetify-nix;
  colors = import ../shared/cols/rose.nix { };
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
    # (import ./conf/utils/direnv/default.nix { })
    # (import ./conf/utils/picom/default.nix { inherit colors pkgs nixpkgs-f2k; })
    # (import ./misc/awesome.nix { inherit pkgs colors; })
    # (import ./misc/eww.nix { inherit config colors; })
    (import ../shared/xresources.nix { inherit colors; })
    (import ./conf/editors/vscopium/default.nix { })
    (import ./conf/music/cava/default.nix { inherit colors; })
    (import ./conf/music/mpd/default.nix { inherit config pkgs; })
    (import ./conf/music/ncmp/default.nix { inherit config pkgs; })
    (import ./conf/music/spicetify/default.nix { inherit colors spicetify-nix pkgs; })
    (import ./conf/shell/zsh/default.nix { inherit config colors pkgs; })
    (import ./conf/shell/nu/default.nix { })
    (import ./conf/term/kitty/default.nix { inherit pkgs colors; })
    (import ./conf/term/wezterm/default.nix { inherit pkgs colors; })
    (import ./conf/term/zellij { inherit pkgs colors; })
    (import ./conf/ui/hyprland/default.nix { inherit config pkgs lib hyprland hyprland-plugins split-monitor-workspaces; })
    (import ./conf/ui/waybar/default.nix { inherit config pkgs lib hyprland colors; })
    (import ./conf/utils/anyrun/default.nix { inherit pkgs anyrun; })
    (import ./conf/utils/dunst/default.nix { inherit colors pkgs; })
    (import ./conf/utils/gpg-agent/default.nix { inherit pkgs; })
    (import ./conf/utils/k9s/default.nix { inherit config colors pkgs; })
    (import ./conf/utils/rofi/default.nix { inherit config pkgs colors; })
    (import ./conf/utils/spotifyd/default.nix { inherit pkgs; })
    (import ./conf/utils/swaylock/default.nix { inherit colors pkgs; })
    (import ./conf/utils/sxhkd/default.nix { })
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
        if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch awesome https://github.com/elythh/dotfiles ${config.home.homeDirectory}/.config/awesome
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/elythh/nvim ${config.home.homeDirectory}/.config/nvim
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/zsh" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch zsh https://github.com/elythh/dotfiles ${config.home.homeDirectory}/.config/zsh
        fi
        # My passwords, you need need that part if you want to use my config
        if [ ! -d "${config.home.homeDirectory}/.config/hypr" ]; then
         ln -s "/etc/nixos/config/hypr/" "${config.home.homeDirectory}/.config/hypr"
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/waybar" ]; then
         ln -s "/etc/nixos/config/waybar/" "${config.home.homeDirectory}/.config/waybar"
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
      activitywatch
      android-tools
      arandr
      awscli
      bc
      betterdiscordctl
      bitwarden
      blueberry
      btop
      catimg
      catppuccin-gtk
      cava
      chafa
      chatterino2
      chromium
      cinnamon.nemo
      cinnamon.nemo-fileroller
      cliphist
      colordiff
      dig
      discord
      dmenu
      docker-compose
      dunst
      emote
      envsubst
      eza
      feh
      ffmpeg_5-full
      flyctl
      fzf
      gcc
      git-lfs
      glib
      glow
      gnome.file-roller
      gnumake
      gnupg
      go
      gojq
      google-cloud-sdk
      gopass
      gopass-jsonapi
      graphite-gtk-theme
      gsettings-desktop-schemas
      helmfile
      hsetroot
      hyprland-autoname-workspaces
      hyprpicker
      i3lock-fancy
      imagemagick
      jellyfin-media-player
      jqp
      just
      k9s
      killall
      krew
      kubecolor
      kubectl
      kubectl-tree
      kubectx
      kubernetes-helm
      lazygit
      light
      lxappearance-gtk2
      mpc-cli
      mpdris2
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
      pass-nodmenu
      passExtensions.pass-import
      pavucontrol
      pax-rs
      payload-dumper-go
      pfetch
      pinentry
      playerctl
      procps
      python311Packages.pip
      python311Packages.setuptools
      python311Packages.virtualenv
      ripgrep
      rose-pine-gtk-theme
      rustup
      scrot
      skim
      slack
      slides
      slurp
      socat
      spotify-tui
      spotifyd
      starship
      stern
      swappy
      swayidle
      swww
      syncthing
      tessen
      thunderbird
      tokyo-night-gtk
      tree-sitter
      vault
      webcord
      wf-recorder
      wl-clipboard
      wlogout
      wlr-randr
      wofi
      xdg-desktop-portal-hyprland
      xh
      xorg.xev
      xss-lock
      yad
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

