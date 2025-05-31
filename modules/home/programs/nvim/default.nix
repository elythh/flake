{ inputs, ... }:
let
  inherit (inputs.neovim.packages."x86_64-linux") neovim;
in
{
  home.packages = [ neovim ];
}
