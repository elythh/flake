{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.meadow.programs.lazygit;
in
{
  options.meadow.programs.lazygit.enable = mkEnableOption "lazygit";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ difftastic ];
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = "3";
          showDivergenceFromBaseBranch = "onlyArrow";
          filterMode = "fuzzy";
          border = "hidden";
          spinner = {
            # The frames of the spinner animation.
            frames = [
              "⠋"
              "⠙"
              "⠩"
              "⠸"
              "⠼"
              "⠴"
              "⠦"
              "⠧"
            ];
            rate = 60;
          };
        };
        git = {
          parseEmoji = true;
          overrideGpg = true;
          diffRenderers = [
            {
              type = "extDiff";
              command = "difft --color=always --syntax-highlight=on --display=inline";
            }
          ];
          commit = {
            signOff = true;
          };
        };
        customCommands = [
          {
            key = "E";
            command = "gitmoji commit";
            description = "commit with gitmoji";
            context = "files";
            loadingText = "opening gitmoji commit tool";
            output = "terminal";
          }
          {
            key = "C";
            command = "wanda git commit";
            description = "commit with cz";
            context = "files";
            loadingText = "opening cz commit tool";
            output = "terminal";
          }
          {
            key = "c";
            command = "git commit";
            description = "commit";
            context = "files";
            loadingText = "opening vim";
            output = "terminal";
          }
        ];
      };
    };
  };
}
