{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge elem;
in
{
  config = mkIf (elem "niri" config.meadow.wms) (mkMerge [
    {
      # Session, systemd units and the gnome portal (screencast) come from the upstream module
      programs.niri.enable = true;

      # niri spawns xwayland-satellite on demand for X11 clients (Steam, games, ...)
      environment.systemPackages = [ pkgs.xwayland-satellite ];
    }

    # https://github.com/YaLTeR/niri/wiki/Nvidia
    # Keeps the driver from hoarding VRAM in the compositor process
    (mkIf (elem "nvidia" config.services.xserver.videoDrivers) {
      environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
        builtins.toJSON {
          rules = [
            {
              pattern = {
                feature = "procname";
                matches = "niri";
              };
              profile = "Limit Free Buffer Pool On Wayland Compositors";
            }
          ];
          profiles = [
            {
              name = "Limit Free Buffer Pool On Wayland Compositors";
              settings = [
                {
                  key = "GLVidHeapReuseRatio";
                  value = 0;
                }
              ];
            }
          ];
        };
    })
  ]);
}
