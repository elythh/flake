{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.neovim.packages.${pkgs.system}.default ];
}
