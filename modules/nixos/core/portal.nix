{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    configPackages = [pkgs.xdg-desktop-portal-hyprland];
    wlr.enable = true;
  };
}
