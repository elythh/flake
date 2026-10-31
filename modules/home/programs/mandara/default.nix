{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  active = config.meadow.programs.shell == "mandara";
in
{
  # https://github.com/theHamdiz/mandara
  # The config is read-only here, so the compositor hooks `mandara setup` would add
  # are declared in each wm module, Mandara still writes its generated drop-ins.
  config = mkIf active (mkMerge [
    {
      home.packages = [ pkgs.mandara ];
    }

    (mkIf (config.meadow.default.wm == "mango") {
      wayland.windowManager.mango = {
        settings.exec_once = [ "mandara" ];
        extraConfig = ''
          source_optional=~/.config/mandara/generated/mango.conf
        '';
      };
    })
  ]);
}
