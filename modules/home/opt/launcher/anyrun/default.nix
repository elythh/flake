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
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          randr
          rink
          shell
          symbols
        ];

        width.fraction = 0.25;
        y.fraction = 0.3;
        hidePluginInfo = true;
        closeOnClick = true;
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
      extraCss = ''
        * {
          all: unset;
          font-size: 1.2rem;
        }

        #window,
        #match,
        #entry,
        #plugin,
        #main {
          background: transparent;
        }

        #match.activatable {
          border-radius: 8px;
          margin: 4px 0;
          padding: 4px;
          /* transition: 100ms ease-out; */
        }
        #match.activatable:first-child {
          margin-top: 12px;
        }
        #match.activatable:last-child {
          margin-bottom: 0;
        }

        #match:hover {
          background: rgba(255, 255, 255, 0.05);
        }
        #match:selected {
          background: rgba(255, 255, 255, 0.1);
        }

        #entry {
          background: rgba(255, 255, 255, 0.05);
          border: 1px solid rgba(255, 255, 255, 0.1);
          border-radius: 8px;
          padding: 4px 8px;
        }

        box#main {
          background: rgba(0, 0, 0, 0.5);
          box-shadow:
            inset 0 0 0 1px rgba(255, 255, 255, 0.1),
            0 30px 30px 15px rgba(0, 0, 0, 0.5);
          border-radius: 20px;
          padding: 12px;
        }
      '';
    };
  };
}
