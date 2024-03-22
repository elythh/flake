{
  inputs,
  pkgs,
  config,
  ...
}: {
  # some general info
  theme = "stardewnight";
  # The global colorScheme, used by most apps
  colorScheme = {
    palette = import ../shared/cols/${config.theme}.nix {};
    name = "${config.theme}";
  };

  home.sessionVariables.EDITOR = "nvim";

  imports = [
    ../shared/hm
    ./options.nix
    ./style.nix

    ./misc/ewwags.nix
    ./misc/obsidian.nix
    ./conf/ui/ags
    # ./conf/ui/wayland/swayfx
    ./conf/ui/wayland/hyprland
    #./conf/utils/swaync

    inputs.anyrun.homeManagerModules.default
    # Importing Configurations
    # ./conf/music/mpd
    # ./conf/music/ncmp/hypr.nix
    ./conf/music/spicetify
    ./conf/shell/zsh
    #./conf/term/kitty
    #./conf/term/foot
    ./conf/term/wezterm
    ./conf/term/zellij
    ./conf/utils/firefox
    ./conf/utils/gpg-agent
    ./conf/utils/k9s
    ./conf/utils/lazygit
    ./conf/utils/lf
    ./conf/utils/rofi
    ./conf/utils/sss
    ./conf/utils/gitui
    ./misc/neofetch.nix
    ./misc/vencord.nix
    ./misc/yamlfmt.nix
    # Bin files
    ../shared/bin/default.nix
  ];
  home = {
    packages = with pkgs; [
      (pkgs.callPackage ../../derivs/discordo.nix {})
      (pkgs.callPackage ../../derivs/phocus.nix {inherit config;})
      (discord.override {withVencord = true;})
      complgen
      fff
      scrcpy
      stremio
      yazi
      showmethekey
    ];
  };
}
