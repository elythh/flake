{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.modules.lazygit.enable {
    programs.lazygit.enable = true;
    home.packages = with pkgs; [ difftastic ];

    home.file.".config/lazygit/config.yml".text = ''
      gui:
        nerdFontsVersion: 3
        showDivergenceFromBaseBranch: onlyArrow
        filterMode: fuzzy
        spinner:
          # The frames of the spinner animation.
          frames:
            - "⠋"
            - "⠙"
            - "⠩"
            - "⠸"
            - "⠼"
            - "⠴"
            - "⠦"
            - "⠧"
          rate: 60
      git:
        parseEmoji: true
        overrideGpg: true
        paging:
          externalDiffCommand: difft --color=always --display=inline --syntax-highlight=on

      customCommands:
        - key: "E"
          command: "gitmoji commit"
          description: "commit with gitmoji"
          context: "files"
          loadingText: "opening gitmoji commit tool"
          subprocess: true
        - key: "C"
          command: "wanda git commit"
          description: "commit with cz"
          context: "files"
          loadingText: "opening cz commit tool"
          subprocess: true
        - key: "c"
          command: "git commit"
          description: "commit"
          context: "files"
          loadingText: "opening vim"
          subprocess: true
    '';
  };
}
