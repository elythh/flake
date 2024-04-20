{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs) spicetify-nix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in {
  imports = [inputs.spicetify-nix.homeManagerModule];
  config = lib.mkIf config.modules.spicetify.enable {
    programs.spicetify = let
      # use a different version of spicetify-themes than the one provided by
      # spicetify-nix
      officialThemesOLD = pkgs.fetchgit {
        url = "https://github.com/spicetify/spicetify-themes";
        rev = "c2751b48ff9693867193fe65695a585e3c2e2133";
        sha256 = "0rbqaxvyfz2vvv3iqik5rpsa3aics5a7232167rmyvv54m475agk";
      };
    in {
      enable = true;
      theme = {
        src = officialThemesOLD;
        name = "Bloom";
        injectCss = true;
        replaceColors = true;
        overwriteAssets = true;
        sidebarConfig = true;
        requiredExtensions = [
          # define extensions that will be installed with this theme
          {
            # extension is "${src}/Dribbblish/dribbblish.js"
            src = "${officialThemesOLD}/Bloom";
            filename = "bloom.js";
          }
        ];
        appendName = true;
      };
      colorScheme = "custom";

      customColorScheme = with config.lib.stylix.colors; {
        text = "${base05}";
        subtext = "${base05}";
        sidebar-text = "${base05}";
        main = "${base00}";
        sidebar = "${base01}";
        player = "${base01}";
        card = "${base00}";
        shadow = "${base03}";
        selected-row = "${base03}";
        button = "${base0F}";
        button-active = "${base05}";
        button-disabled = "${base0E}";
        tab-active = "${base03}";
        notification = "${base0A}";
        notification-error = "${base0F}";
        misc = "${base05}";
        alt-text = "${base05}";
        player-bar-bg = "${base01}";
        accent = "${base06}";
      };
      enabledExtensions = with spicePkgs.extensions; [
        playlistIcons
        lastfm
        #genre
        historyShortcut
        spicetify-nix.packages.${pkgs.system}.default.extensions.adblock
        hidePodcasts
        fullAppDisplay
        shuffle
      ];
    };
  };
}
