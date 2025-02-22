{ pkgs, ... }:
{
  home.packages = pkgs.lib.flatten (
    with pkgs;
    [
      bat
      eza
      fd
      ripgrep
      fzf
      lazydocker
      lazygit
      btop
      bitwarden
      gh
      vesktop

      [
        (mpv.override { scripts = [ mpvScripts.mpris ]; })
        spotify
        fragments
      ]
    ]
  );
}
