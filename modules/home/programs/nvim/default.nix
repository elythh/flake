{ inputs, ... }:
{
  imports = [ inputs.neovim.homeModules.default ];
  nvim.enable = true;
}
