{
  inputs,
  pkgs,
  ...
}:
{

  imports = [
    ./shared
    inputs.stylix.homeModules.stylix
    inputs.noctalia.homeModules.default
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
      terminal = "ghostty";
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
      (pkgs.lutris.override {
        # Intercept buildFHSEnv to modify target packages
        buildFHSEnv =
          args:
          pkgs.buildFHSEnv (
            args
            // {
              multiPkgs =
                envPkgs:
                let
                  # Fetch original package list
                  originalPkgs = args.multiPkgs envPkgs;

                  # Disable tests for openldap
                  customLdap = envPkgs.openldap.overrideAttrs (_: {
                    doCheck = false;
                  });
                in
                # Replace broken openldap with the custom one
                builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
            }
          );
      })
      zoom-us
      mangohud
      deadlock-mod-manager
      cider-2
      heroic
      gnome-disk-utility
      vial
      qbittorrent
      dorion
    ];
  };
}
