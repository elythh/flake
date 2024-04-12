{pkgs, ...}: {
  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
    zsh.enable = true;
    dconf.enable = true;
  };
  imports = [
    ./steam.nix
  ];
}
