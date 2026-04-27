{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.darwin-flake.modules.homeManager.ghostty ];

  config = lib.mkIf (config.meadow.default.terminal == "ghostty") {
    home.sessionVariables.TERMINAL = "ghostty";
    programs.ghostty.package = lib.mkForce pkgs.ghostty;
  };
}
