{ inputs, config, pkgs, lib, ... }:

let
  spicetify-nix = inputs.spicetify-nix;
  colors = import ../shared/cols/wave.nix { };
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
  home.stateVersion = "23.05";
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
    (import ./misc/awesome.nix { inherit pkgs colors; })
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
        if [ ! -d "${config.home.homeDirectory}/workspace/private" ]; then
          ${pkgs.git}/bin/git clone https://git.elyth.xyz/Elyth/private ${config.home.homeDirectory}/workspace/private
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/hypr" ]; then
         ln -s "/etc/nixos/config/hypr/" "${config.home.homeDirectory}/.config/hypr"
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
      eza
      feh
      ffmpeg_5-full
      flyctl
      fzf
      gcc
      git-lfs
      glow
      gnome.file-roller
      gnumake
      gnupg
      go
      google-cloud-sdk
      haskellPackages.arbtt
      helmfile
      hsetroot
      i3lock-fancy
      imagemagick
      jellyfin-media-player
      jqp
      just
      hyprpicker
      k9s
      killall
      krew
      kubecolor
      kubectl-tree
      kubectx
      kubernetes-helm
      lazygit
      light
      mpc-cli
      mpdris2
      mullvad-vpn
      neofetch
      neovim
      networkmanagerapplet
      ncdu
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
      python311Packages.pip
      python311Packages.setuptools
      python311Packages.virtualenv
      ripgrep
      rofi-pass
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
      swww
      syncthing
      thunderbird
      tree-sitter
      vault
      webcord
      wf-recorder
      wofi
      wl-clipboard
      wlr-randr
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
}

