{ inputs, ... }:
{
  imports = [
    inputs.hm.nixosModule
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
    inputs.grub2-themes.nixosModules.default

    ./hardware-configuration.nix
  ];
  networking.hostName = "grovetender"; # Define your hostname.

  opt = {
    services = {
      xserver.enable = true;
    };
  };

  tailscale.enable = true;
  fonts.enable = true;
  wayland.enable = true;
  pipewire.enable = true;
  steam.enable = false;
  tpm.enable = true;
}
