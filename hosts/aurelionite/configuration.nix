{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];
  networking.hostName = "aurelionite"; # Define your hostname.

  tailscale.enable = true;
  fonts.enable = true;
  wayland.enable = true;
  pipewire.enable = true;
}
