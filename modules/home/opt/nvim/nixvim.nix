{
  inputs,
  config,
  lib,
  ...
}:
let
  enable-avante-module = {
    plugins.avante = {
      enable = lib.mkForce true;
    };
  };
  set-custom-theme-module = {
    theme = lib.mkForce "${config.theme}";
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
    };
  };
  inherit (inputs.nixvim.nixvimConfigurations."x86_64-linux") nixvim;
  nixvimExtended = nixvim.extendModules {
    modules = [
      enable-avante-module
      set-custom-theme-module
    ];
  };
  elythvim = nixvimExtended.config.build.package;
in
{
  home.packages = [ elythvim ];
}
