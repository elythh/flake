{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    envExtra = ''
      ZDOTDIR=${config.home.homeDirectory}/.config/zsh/
    '';
  };
}




































