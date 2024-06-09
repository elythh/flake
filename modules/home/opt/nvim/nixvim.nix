{
  inputs,
  lib,
  ...
}: let
  nixvim' = inputs.nixvim.packages."x86_64-linux".default;
  nvim = nixvim'.nixvimExtend {
    config = {
      theme = lib.mkForce "paradise";
      plugins.obsidian.enable = lib.mkForce true;
    };
  };
in {
  home.packages = [
    nvim
  ];
}
