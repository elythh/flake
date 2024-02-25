{ inputs, nix-colors, config, pkgs, ... }:
let
  inherit (inputs) spicetify-nix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in {
  imports = [ inputs.spicetify-nix.homeManagerModule ];
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

    customColorScheme = with config.colorscheme.palette; {
      text = "${foreground}";
      subtext = "${color15}";
      sidebar-text = "${color7}";
      main = "${background}";
      sidebar = "${mbg}";
      player = "${mbg}";
      card = "${color0}";
      shadow = "${color8}";
      selected-row = "${color8}";
      button = "${accent}";
      button-active = "${foreground}";
      button-disabled = "${color5}";
      tab-active = "${accent}";
      notification = "${color3}";
      notification-error = "${color1}";
      misc = "${comment}";
      alt-text = "${comment}";
      player-bar-bg = "${darker}";
      accent = "${accent}";
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
}
