{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.opt.utils.lazygit;
in
{
  options.opt.utils.lazygit.enable = mkEnableOption "lazygit";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ difftastic ];
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = 3;
          showDivergenceFromBaseBranch = "onlyArrow";
          filterMode = "fuzzy";
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
            # externalDiffCommand = "difft --color=always --syntax-highlight=on";
            colorArg = "always";
            pager = "${lib.getExe pkgs.diff-so-fancy}";
          };
        };
        customCommands = [
          {
            key = "E";
            command = "gitmoji commit";
            description = "commit with gitmoji";
            context = "files";
            loadingText = "opening gitmoji commit tool";
            subprocess = true;
          }
          {
            key = "C";
            command = "wanda git commit";
            description = "commit with cz";
            context = "files";
            loadingText = "opening cz commit tool";
            subprocess = true;
          }
          {
            key = "c";
            command = "git commit";
            description = "commit";
            context = "files";
            loadingText = "opening vim";
            subprocess = true;
          }
        ];
      };
    };
  };
}
