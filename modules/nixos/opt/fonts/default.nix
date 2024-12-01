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
      google-fonts

      nerd-fonts.fira-code
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.zed-mono
      nerd-fonts.iosevka
      nerd-fonts.monaspace
    ];
  };
}
