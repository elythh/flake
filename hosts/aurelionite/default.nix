{ inputs, ... }:
{
  imports = [
    inputs.hm.nixosModule
    inputs.grub2-themes.nixosModules.default

    ./hardware-configuration.nix
  ];
  networking.hostName = "aurelionite"; # Define your hostname.

  opt = {
    services = {
      xserver.enable = true;
    };
  };

  tailscale.enable = true;
  fonts.enable = true;
  wayland.enable = true;
  pipewire.enable = true;
  tpm.enable = true;
}
