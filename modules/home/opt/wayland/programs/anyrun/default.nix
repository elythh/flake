{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.modules.anyrun.enable {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          rink
          shell
          symbols
          translate
          websearch
        ];

        width.fraction = 0.5;
        y.absolute = 5;
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = true;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = 10;
      };

      extraCss = builtins.readFile (./. + "/styleAnyrun.css");

      extraConfigFiles = {
        "applications.ron".text = ''
          Config(
            desktop_actions: true,
            max_entries: 10,
            terminal: Some("${config.home.sessionVariables.TERMINAL}"),
          )
        '';

        "translate.ron".text = ''
          Config(
            prefix: ":tr",
            language_delimiter: ">",
            max_entries: 5,
          )
        '';
      };
    };
  };
}
