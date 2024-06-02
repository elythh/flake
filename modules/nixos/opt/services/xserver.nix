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
      defaultSession = "none+awesome";
      startx.enable = true;
    };
    windowManager.awesome = {
      enable = true;
    };
    desktopManager.gnome.enable = false;
  };
}
