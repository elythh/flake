{
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.meadow.services.vicinae;
in
{
  options.meadow.services.vicinae = {
    enable = mkEnableOption "vicinae launcher daemon" // {
      default = true;
    };

    package = mkOption {
      type = types.package;
      default = vicinae;
      defaultText = literalExpression "vicinae";
      description = "The vicinae package to use.";
    };

  };

  imports = [ inputs.vicinae.homeManagerModules.default ];
  config = mkIf cfg.enable {
    services.vicinae = {
      enable = true;
    };
  };
}
