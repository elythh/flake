{
  inputs,
  ...
}:
let
  inherit (inputs.nixvim.packages."x86_64-linux") neovim;
in
{
  home.packages = [ neovim ];
}
