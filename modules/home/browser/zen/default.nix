{
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.meadow.browser.zen;

  inherit (lib) mkIf mkEnableOption;
in
{
  options.meadow.browser.zen = {
    enable = mkEnableOption "Wether to enable zen";
  };

  imports = [ inputs.zen-browser.homeModules.beta ];
  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      profiles.default.sine.enable = true;
    };
  };
}
