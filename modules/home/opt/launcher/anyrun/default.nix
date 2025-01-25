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
      extraCss = with config.lib.stylix.colors.withHashtag; ''
        /* Global */
        * {
          all: unset;
          font-family: "GeistMono Nerd Font Propo", sans-serif;
          font-size: 11pt;
          font-weight: 500;
          transition: 300ms;
        }

        /* Modules */
        #window,
        #match,
        #entry,
        #plugin,
        #main {
          background: transparent;
        }

        /* Entry */
        #entry {
          background: ${base01};
          border-radius: 12px;
          margin: 0.5rem;
          padding: 0.5rem;
        }

        /* Match  */
        #match.activatable {
          background: ${base01};
          padding: 0.5rem 1rem;
        }

        #match.activatable:first-child {
          border-radius: 12px 12px 0 0;
        }

        #match.activatable:last-child {
          border-radius: 0 0 12px 12px;
        }

        #match.activatable:only-child {
          border-radius: 12px;
        }

        /* Hover and selected states */
        #match:selected,
        #match:hover,
        #plugin:hover {
          background: lighter(${base01});
        }

        /* Main container */
        box#main {
          background: ${base00};
          border-radius: 12px;
          padding: 0.5rem;
        }

        /* Plugin within list */
        list > #plugin {
          border-radius: 12px;
          margin: 0.5rem;
        }
      '';
    };
  };
}
