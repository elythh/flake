{ inputs
, config
, lib
, ...
}:
let
  nixvim' = inputs.nixvim.packages."x86_64-linux".default;
  nvim = nixvim'.nixvimExtend {
    config = {
      theme = lib.mkForce "${config.theme}";
      plugins.obsidian.enable = lib.mkForce true;
      assistant = "copilot";
    };
  };
in
{
  home.packages = [
    nvim
  ];
}
