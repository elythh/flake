{
  inputs,
  pkgs,
  ...
}:
{

  imports = [
    ./shared
    inputs.stylix.homeModules.stylix
    inputs.caelestia.homeManagerModules.default
    inputs.dms.homeModules.dank-material-shell
    inputs.noctalia.homeModules.default
    inputs.mango.hmModules.mango
    ../../modules/home
  ];
  meadow = {
    programs = {
      atuin.enable = true;
      spicetify.enable = true;
      shell = "noctalia";
      # zellij.enable = true;
      tmux.enable = true;
    };

    services = {
      hypridle.enable = false;
      quicksome.enable = false;
    };

    default = {
      shell = [
        "fish"
      ];
      terminal = "ghostty";
      wm = "hyprland";
    };
  };

  # Specific packages for this home-manager host config
  home = {
    packages = with pkgs; [
      teleport-connect
      teeworlds # very important to work
      distrobox
      (wineWow64Packages.full.override {
        wineRelease = "staging";
        mingwSupport = true;
      })
      winetricks
      wowup-cf
      feishin
      stremio-linux-shell
      easyeffects
      r2modman
      lutris
      zoom-us
      mangohud
      deadlock-mod-manager
      cider-2
      heroic
      gnome-disk-utility
      vial
      qbittorrent
      webcord-vencord
      thunar
      zenity
      inputs.fastpotify.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
