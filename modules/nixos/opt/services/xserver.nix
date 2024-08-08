{
  services = {
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        middleEmulation = true;
        naturalScrolling = true;
      };
    };
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      desktopManager.gnome.enable = false;
    };
    displayManager = {
      defaultSession = "none+hyprland";
    };
  };
}
