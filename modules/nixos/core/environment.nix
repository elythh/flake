{pkgs, ...}: {
  environment.shells = with pkgs; [zsh];
}
