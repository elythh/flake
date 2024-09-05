#              ╭──────────────────────────────────────────────────╮
#              │             CREDITS TO: @khaneliman              │
#              │ THIS IS A FORK OF HIS CONFIG, ALL CREDITS TO HIM │
#              ╰──────────────────────────────────────────────────╯
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (inputs) anyrun;
  inherit (pkgs) system;
  opacity = toString config.stylix.opacity.popups;

  cfg = config.opt.launcher.anyrun;
in
{
  options.opt.launcher.anyrun.enable = mkEnableOption "Anyrun";

  config = mkIf cfg.enable {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = with anyrun.packages.${system}; [
          applications
          dictionary
          rink
          shell
          symbols
          stdin
          translate
          websearch
        ];

        # the x coordinate of the runner
        #x.relative = 800;
        # the y coordinate of the runner
        #y.absolute = 500.0;
        y.fraction = 2.0e-2;

        # Hide match and plugin info icons
        hideIcons = false;

        # ignore exclusive zones, i.e. Waybar
        ignoreExclusiveZones = false;

        # Layer shell layer: Background, Bottom, Top, Overlay
        layer = "overlay";

        # Hide the plugin info panel
        hidePluginInfo = false;

        # Close window when a click outside the main box is received
        closeOnClick = false;

        # Show search results immediately when Anyrun starts
        showResultsImmediately = false;

        # Limit amount of entries shown in total
        maxEntries = 10;
      };

      extraConfigFiles = {
        "applications.ron".text = ''
          Config(
            // Also show the Desktop Actions defined in the desktop files, e.g. "New Window" from LibreWolf
            desktop_actions: true,
            max_entries: 10,
            // The terminal used for running terminal based desktop entries, if left as `None` a static list of terminals is used
            // to determine what terminal to use.
            terminal: Some("foot"),
          )
        '';

        "symbols.ron".text = ''
          Config(
            // The prefix that the search needs to begin with to yield symbol results
            prefix: ":sy",

            // Custom user defined symbols to be included along the unicode symbols
            symbols: {
              // "name": "text to be copied"
              "shrug": "¯\\_(ツ)_/¯",
            },

            // The number of entries to be displayed
            max_entries: 5,
          )
        '';

        # NOTE: usage information
        # <prefix><src lang><language_delimiter><target lang> <text to translate>
        # ie: ':trenglish>spanish test this out'
        # <prefix><target lang> <text to translate>
        # ie: ':trspanish test this out'
        "translate.ron".text = ''
          Config(
            prefix: ":tr",
            language_delimiter: ">",
            max_entries: 3,
          )
        '';

        "websearch.ron".text = ''
          Config(
            prefix: "?",
            engines: [DuckDuckGo] 
          )
        '';
      };

      # this compiles the SCSS file from the given path into CSS
      # by default, `-t expanded` as the args to the sass compiler
      extraCss = with config.lib.stylix.colors; ''
        $fontSize: 1.3rem;
        $fontFamily: Lexend;
        $transparentColor: transparent;
        $rgbaColor: rgba(203, 166, 247, 0.7);
        $bgColor: rgba(30, 30, 46, 1);
        $borderColor: #494d64;
        $borderRadius: 16px;
        $paddingValue: 8px;

        * {
        	transition: 200ms ease;
        	font-family: Lexend;
        	font-size: 1.3rem;
        }

        #window,
        #match,
        #entry,
        #plugin,
        #main {
        	background: transparent;
        }

        #match:selected {
        	background: "rgba(${base01-rgb-r}, ${base01-rgb-g}, ${base01-rgb-b}, ${opacity})";
        }

        #match {
        	padding: 3px;
        	border-radius: 6px;
        }

        #entry,
        #plugin:hover {
        	border-radius: 6px;;
        }

        box#main {
        	background: ${base01};
        	border: 2px solid ${base00};
        	border-radius: 6px;
        	padding: 8px;
        }

      '';
    };
  };
}
