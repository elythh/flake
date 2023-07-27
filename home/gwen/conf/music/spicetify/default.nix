{ colors, spicetify-nix, pkgs }:
let
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
        rev = "b2269a9650b735b955d5b024d69c7a38022d4a7e";
        sha256 = "pWMswQJ7uGBPTmlZjdHoBXdVAOr3VKv+PbKZt0+G2Qg=";
      };
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        playlistIcons
        # spicetify-nix.packages.${pkgs.system}.default.extensions.adblock
        genre
        historyShortcut
        # hidePodcasts
        # fullAppDisplay
        shuffle
      ];
      colorScheme = "Spotify";
      theme = {
        name = "text";
        src = officialThemesOLD;
        appendName = true; # theme is located at "${src}/Dribbblish" not just "${src}"
        injectCss = true;
        replaceColors = true;
        overwriteAssets = true;
        sidebarConfig = true;
      };
      # color definition for custom color scheme. (rosepine)
      customColorScheme = with colors;
        {
          text = "${color7}";
          subtext = "${color15}";
          sidebar-text = "${color7}";
          main = "${background}";
          sidebar = "${mbg}";
          player = "${bg2}";
          card = "${color0}";
          shadow = "${color8}";
          selected-row = "${color8}";
          button = "${color4}";
          button-active = "${color4}";
          button-disabled = "${color5}";
          tab-active = "${color4}";
          notification = "${color3}";
          notification-error = "${color1}";
          misc = "${comment}";
        };


    };
}

