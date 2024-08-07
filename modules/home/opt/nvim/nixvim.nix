{
  inputs,
  config,
  lib,
  ...
}:
let
  nixvim' = inputs.nixvim.packages."x86_64-linux".default;
  nixvim = nixvim'.extend {
    config = {
      colorschemes.base16 = {
        colorscheme = lib.mkForce {
          inherit (config.lib.stylix.colors.withHashtag)
            base00
            base01
            base02
            base03
            base04
            base05
            base06
            base07
            base08
            base09
            base0A
            base0B
            base0C
            base0D
            base0E
            base0F
            ;
        };
        enable = lib.mkForce true;
      };
      plugins.obsidian.enable = lib.mkForce true;
      assistant = "copilot";
    };
  };
in
{
  home.packages = [ nixvim ];
}
