{ ... }:
{
  home.file.".config/lazygit/config.yml".text = ''
    git:
      parseEmoji: true

    customCommands:
      - key: "C"
        command: "gitmoji commit"
        description: "commit with gitmoji"
        context: "files"
        loadingText: "opening gitmoji commit tool"
        subprocess: true
  '';
}






