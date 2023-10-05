{ inputs, config, pkgs, lib, ... }:

let
  spicetify-nix = inputs.spicetify-nix;
  colors = import ../shared/cols/rose.nix { };
  hyprland = inputs.hyprland;
  hyprland-plugins = inputs.hyprland-plugins;
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
  };
  imports = [
    # Importing Configurations
    (import ../shared/xresources.nix { inherit colors; })
    #    (import ./conf/utils/direnv/default.nix { })
    (import ./conf/editors/vscopium/default.nix { })
    (import ./conf/music/cava/default.nix { inherit colors; })
    (import ./conf/music/mpd/default.nix { inherit config pkgs; })
    (import ./conf/music/ncmp/default.nix { inherit config pkgs; })
    (import ./conf/music/spicetify/default.nix { inherit colors spicetify-nix pkgs; })
    (import ./conf/shell/zsh/default.nix { inherit config colors pkgs; })
    (import ./conf/term/kitty/default.nix { inherit pkgs colors; })
    (import ./conf/term/wezterm/default.nix { inherit pkgs colors; })
    (import ./conf/term/zellij { inherit pkgs colors; })
    (import ./conf/ui/hyprland/default.nix { inherit config pkgs lib hyprland hyprland-plugins colors; })
    (import ./conf/ui/waybar/default.nix { inherit config pkgs lib hyprland colors; })
    (import ./conf/utils/gpg-agent/default.nix { inherit pkgs; })
    (import ./conf/utils/k9s/default.nix { inherit config colors pkgs; })
    (import ./conf/utils/keybase/default.nix { inherit pkgs; })
    (import ./conf/utils/picom/default.nix { inherit colors pkgs nixpkgs-f2k; })
    (import ./conf/utils/rofi/default.nix { inherit config pkgs colors; })
    (import ./conf/utils/spotifyd/default.nix { inherit pkgs; })
    (import ./conf/utils/swaylock/default.nix { inherit colors pkgs; })
    (import ./conf/utils/sxhkd/default.nix { })
    (import ./conf/utils/dunst/default.nix { inherit colors pkgs; })
    (import ./conf/utils/anyrun/default.nix { inherit pkgs anyrun; })
    # (import ./misc/awesome.nix { inherit pkgs colors; })
    #(import ./misc/eww.nix { inherit config colors; })
    (import ./misc/neofetch.nix { inherit config colors; })
    (import ./misc/xinit.nix { })
    (import ./misc/betterdiscord.nix { inherit config colors; })
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
      betterdiscordctl
      bitwarden
      blueberry
      btop
      catimg
      catppuccin-gtk
      cava
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
      google-cloud-sdk
      graphite-gtk-theme
      gsettings-desktop-schemas
      haskellPackages.arbtt
      helmfile
      hsetroot
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
      kubectl-tree
      kubectx
      kubernetes-helm
      lazygit
      light
      lxappearance-gtk2
      mpc-cli
      mpdris2
      mullvad-vpn
      niv
      ncdu
      neofetch
      neovim
      networkmanagerapplet
      nodePackages.typescript-language-server
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-json-languageserver
      obsidian
      openvpn
      pass-nodmenu
      pavucontrol
      pfetch
      pinentry
      playerctl
      procps
      pax-rs
      python311Packages.pip
      python311Packages.setuptools
      python311Packages.virtualenv
      ripgrep
      rofi-pass
      rose-pine-gtk-theme
      rustup
      scrot
      slack
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
      thunderbird
      tokyo-night-gtk
      tree-sitter
      vault
      webcord
      wf-recorder
      wl-clipboard
      wlr-randr
      wofi
      wlogout
      xdg-desktop-portal-hyprland
      xh
      yad
      gojq
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
}

