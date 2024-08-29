{
  inputs,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (inputs) spicetify;
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  spicePkgs = spicetify.legacyPackages.${pkgs.system};

  cfg = config.${namespace}.programs.graphical.apps.spicetify;
in
{
  options.${namespace}.programs.graphical.apps.spicetify = {
    enable = mkBoolOpt false "Wether to enable spicetify";
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.comfy;
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
    };
  };
}
