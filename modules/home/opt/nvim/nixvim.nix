{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [ inputs.nixvim.packages.${pkgs.system}.default ];
}
