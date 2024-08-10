{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "aurelionite"; # Define your hostname.

  tailscale.enable = true;
  fonts.enable = true;
  wayland.enable = true;
  pipewire.enable = true;
}
