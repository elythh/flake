{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.tools.lazygit;
in
{
  options.${namespace}.programs.terminal.tools.lazygit = {
    enable = mkBoolOpt false "Whether or not to enable lazygit.";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      gitmoji-cli
    ];

    programs.lazygit = {
      enable = true;

      settings = {
        gui = {
          authorColors = {
            "${config.${namespace}.user.fullName}" = "#c6a0f6";
            "dependabot[bot]" = "#eed49f";
          };
          branchColors = {
            main = "#ed8796";
            master = "#ed8796";
            dev = "#8bd5ca";
          };
        };
        git = {
          overrideGpg = true;
          parseEmoji = true;
        };
        customCommands = [
          {
            key = "E";
            command = "gitmoji commit";
            description = "Use gitmoji  to commit";
            context = "files";

          }
        ];
      };
    };

    home.shellAliases = {
      lg = "lazygit";
    };
  };
}
