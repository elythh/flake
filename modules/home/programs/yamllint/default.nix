{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.meadow.programs.yamllint;
in
{
  options.meadow.programs.yamllint = {
    enable = mkEnableOption "Wether to enable yamllint";
  };
  config = mkIf cfg.enable {
    home.file.".config/yamllint/config".text = ''
      yaml-files:
        - '*.yaml'
        - '*.yml'
        - '.yamllint'

      rules:
        anchors: enable
        braces: enable
        brackets: enable
        colons: enable
        commas: enable
        comments:
          level: warning
        comments-indentation:
          level: warning
        document-end: disable
        document-start:
          level: warning
        empty-lines: enable
        empty-values: disable
        float-values: disable
        hyphens: enable
        indentation: enable
        key-duplicates: enable
        key-ordering: disable
        line-length: disable
        new-line-at-end-of-file: enable
        new-lines: enable
        octal-values: disable
        quoted-strings: disable
        trailing-spaces: enable
        truthy:
          level: warning
    '';
  };
}
