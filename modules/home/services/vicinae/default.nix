{
  config,
  lib,
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

  config = mkIf cfg.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;

      settings = {
        window.opacity = 1;
      };
    };
  };
}
