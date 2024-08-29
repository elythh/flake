{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.fonts.enable {
    fonts.packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      rubik
      lexend
      noto-fonts
      roboto

      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "FantasqueSansMono"
          "ZedMono"
          "Iosevka"
          "JetBrainsMono"
          "Monaspace"
        ];
      })
    ];
  };
}
