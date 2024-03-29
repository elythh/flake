{
  home.file.".config/lazygit/config.yml".text = ''
    gui:
      nerdFontsVersion: 3
    git:
      parseEmoji: true

    customCommands:
      - key: "C"
        command: "gitmoji commit"
        description: "commit with gitmoji"
        context: "files"
        loadingText: "opening gitmoji commit tool"
        subprocess: true
      - key: "c"
        command: "wanda git commit"
        description: "commit with cz"
        context: "files"
        loadingText: "opening cz commit tool"
        subprocess: true
  '';
}
