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
          nerdFontsVersion = 3;
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
          paging = {
            externalDiffCommand = "difft --color=always --syntax-highlight=on --display=inline";
            colorArg = "never";
            # pager = "${lib.getExe pkgs.ydiff} -p cat -s --wrap --width={{columnWidth}}";
          };
          commit = {
            signoff = true;
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
