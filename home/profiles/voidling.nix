{
  inputs,
  pkgs,
  ...
}:
{

  imports = [
    ./shared
    inputs.stylix.homeModules.stylix
    inputs.dms.homeModules.dank-material-shell
    ../../modules/home
  ];
  meadow = {
    programs = {
      atuin.enable = true;
      spicetify.enable = true;
      # zellij.enable = true;
      tmux.enable = true;
    };

    services = {
      hypridle.enable = false;
    };

    default = {
      shell = [
        "fish"
      ];
      terminal = "kitty";
    };
  };

  # Specific packages for this home-manager host config
  home = {
    packages = with pkgs; [
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
    ];
  };
}
