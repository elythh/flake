{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.modules.k9s.enable {
    programs.k9s = {
      enable = true;

      settings.skin = "k9s";
    };
  };
}
