{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.uwsm = {
    waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/Hyprland";
    };
    waylandCompositors.sway = {
      prettyName = "SwayFX";
      comment = "SwayFX compositor managed by UWSM";
      binPath = "/etc/profiles/per-user/gwen/bin/sway";
    };
  };
}
