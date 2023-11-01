{ inputs, pkgs, config, nix-colors, ... }:
let
  spicetify-nix = inputs.spicetify-nix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
  imports = [ spicetify-nix.homeManagerModule ];
  programs.spicetify =
    let
      # use a different version of spicetify-themes than the one provided by
      # spicetify-nix
      officialThemesOLD = pkgs.fetchgit {
        url = "https://github.com/spicetify/spicetify-themes";
        rev = "e4a15de2e02642c7d5ba2cde6cb610dc3c9fac91";
        sha256 = "11dlxkd2kk8d9ppb2wfr1a00dzxjbsqha3s0q7wjx40bzy97fdb9";
      };
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        playlistIcons
        genre
        historyShortcut
        hidePodcasts
        fullAppDisplay
        shuffle
      ];
      colorScheme = "custom";
      theme = {
        name = "Dribbblish";
        src = officialThemesOLD;
        requiredExtensions = [
          # define extensions that will be installed with this theme
          {
            # extension is "${src}/Dribbblish/dribbblish.js"
            filename = "dribbblish.js";
            src = "${officialThemesOLD}/Dribbblish";
          }
        ];
        appendName = true; # theme is located at "${src}/Dribbblish" not just "${src}"

        # changes to make to config-xpui.ini for this theme:
        patches = {
          "xpui.js_find_8008" = ",(\\w+=)32,";
          "xpui.js_repl_8008" = ",$\{1}56,";
        };
        injectCss = true;
        replaceColors = true;
        overwriteAssets = true;
        sidebarConfig = true;
      };

      # color definition for custom color scheme. (rosepine)
      customColorScheme = with config.colorScheme.colors;{
        text = "${base08}";
        subtext = "${base0A}";
        sidebar-text = "${base03}";
        main = "${base00}";
        sidebar = "${base02}";
        player = "${base04}";
        card = "${base02}";
        shadow = "${base00}";
        selected-row = "${base04}";
        button = "${base0D}";
        button-active = "${base08}";
        button-disabled = "${base07}";
        tab-active = "${base0D}";
        notification = "${base0C}";
        notification-error = "${base08}";
        misc = "${base03}";
      };

    };
}

