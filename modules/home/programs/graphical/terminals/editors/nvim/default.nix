{
  inputs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.editors.neovim;

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
      plugins.indent-blankline.enable = lib.mkForce false;
      assistant = "copilot";
    };
  };
in
{
  options.${namespace}.programs.terminal.editors.neovim = {
    enable = mkEnableOption "neovim";
    default = mkBoolOpt true "Whether to set Neovim as the session EDITOR";
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = "nvim";

      };
      packages = [ nixvim ];
    };
  };
}
