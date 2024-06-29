{
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        middleEmulation = true;
        naturalScrolling = true;
      };
    };
    displayManager = {
      defaultSession = "none+hyprland";
      startx.enable = false;
    };
    desktopManager.gnome.enable = false;
  };
}
