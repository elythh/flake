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

  # Start EasyEffects in the background with the graphical session
  services.easyeffects.enable = true;

  # Nexus "Mod Manager Download" links, sent to Mod Organizer 2 through steam-run
  xdg.desktopEntries.mo2-nxm-handler = {
    name = "Mod Organizer 2 NXM Handler";
    exec = "${pkgs.mo2-lint}/bin/mo2-nxm-handler %u";
    mimeType = [ "x-scheme-handler/nxm" ];
    noDisplay = true;
  };
  xdg.mimeApps.defaultApplications."x-scheme-handler/nxm" = [ "mo2-nxm-handler.desktop" ];

  # Specific packages for this home-manager host config
  home = {
    packages = with pkgs; [
      teleport-connect
      mo2-lint
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
      r2modman
      prismlauncher
      lutris
      zoom-us
      mangohud
      deadlock-mod-manager
      cider-2
      pulsemeeter
      heroic
      gnome-disk-utility
      vial
      qbittorrent
      webcord-vencord
      thunar
      zenity
      inputs.fastpotify.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.tuios.packages.${pkgs.stdenv.hostPlatform.system}.default
      equibop
    ];
  };
}
