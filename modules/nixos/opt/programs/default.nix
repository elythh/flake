{ pkgs, ... }:
{
  programs = {
    nix-ld.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
    zsh.enable = true;
    fish.enable = true;
    dconf.enable = true;
    wshowkeys.enable = true;
  };
  imports = [ ./steam.nix ];
}
