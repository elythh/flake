{ inputs, config, pkgs, lib, ... }:

let
  spicetify-nix = inputs.spicetify-nix;
  colors = import ../shared/cols/groove.nix { };

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
    (import ./conf/music/cava/default.nix { inherit colors; })
    #    (import ./conf/shell/zsh/default.nix { inherit config pkgs; })
    (import ./conf/term/kitty/default.nix { inherit pkgs colors; })
    (import ./conf/editors/vscopium/default.nix { })
    (import ./conf/music/spicetify/default.nix { inherit colors spicetify-nix pkgs; })
    (import ./conf/utils/sxhkd/default.nix { })
    (import ./conf/utils/picom/default.nix { inherit colors pkgs nixpkgs-f2k; })
    (import ./conf/music/mpd/default.nix { inherit config pkgs; })
    (import ./conf/music/ncmp/default.nix { inherit config pkgs; })
    (import ./misc/awesome.nix { inherit pkgs colors; })
    (import ./misc/neofetch.nix { inherit config colors; })
    (import ./misc/xinit.nix { })

    (import ./conf/term/zellij { inherit pkgs colors; })

    # Bin files
    (import ../shared/bin/default.nix { inherit config colors; })
    (import ../shared/lock.nix { inherit colors; })
  ];
  home = {
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch awesome https://github.com/elythh/nix-home ${config.home.homeDirectory}/.config/awesome
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ${pkgs.git}/bin/git clone --depth 1 https://git.elyth.xyz/Elyth/nvim ${config.home.homeDirectory}/.config/nvim
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/zsh" ]; then
          cp -r "/etc/nixos/config/zsh" "${config.home.homeDirectory}/.config/zsh"
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/starship.toml" ]; then
          cp "/etc/nixos/config/starship/starship.toml" "${config.home.homeDirectory}/.config/starship.toml"
        fi
      '';
    };
    packages = with pkgs; [
      starship
      zellij
      fzf
      python310Packages.pip
      kubectl
      bc
      google-cloud-sdk
      chromium
      slack
      catimg
      xss-lock
      chatterino2
      playerctl
      (pkgs.callPackage ../shared/icons/whitesur.nix { })
      (pkgs.callPackage ../../derivs/phocus.nix { inherit colors; })
      cinnamon.nemo
      neofetch
      hsetroot
      pfetch
      ffmpeg_5-full
      neovim
      xdg-desktop-portal
      imagemagick
      xorg.xev
      procps
      killall
      btop
      cava
      mpdris2
      pavucontrol
      feh
      exa
      lazygit
      obsidian
      bitwarden
      android-tools
      stern
      syncthing
      jellyfin-media-player
    ];
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };
}

