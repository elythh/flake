{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];
  networking.hostName = "grovetender"; # Define your hostname.

  tailscale.enable = true;
  fonts.enable = true;
  wayland.enable = true;
  pipewire.enable = true;
  steam.enable = false;
}
