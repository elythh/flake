{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.opt.utils.sss;
in
{
  options.opt.utils.sss.enable = mkEnableOption "sss";

  imports = [ inputs.sss.nixosModules.home-manager ];

  config = mkIf cfg.enable {
    programs.sss = {
      enable = true;

      # General Config
      general = with config.lib.stylix.colors; {
        colors = {
          background = "#${base0B}";
          author = "#${base01}";
          shadow = "#${base00}";
        };
        fonts = "Product Sans=12.0";
        radius = 8;
        save-format = "png";
        shadow = true;
        shadow-image = true;
      };
      code.enable = true;
    };
  };
}
