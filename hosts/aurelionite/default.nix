{ inputs, ... }:
{
  imports = [
    inputs.hm.nixosModules.default
    inputs.grub2-themes.nixosModules.default

    ./hardware.nix
  ];
  networking.hostName = "aurelionite"; # Define your hostname.

  opt = {
    services = {
      xserver.enable = true;
      kanata.enable = true;
    };
  };

  tailscale.enable = true;
  fonts.enable = true;
  wayland.enable = true;
  pipewire.enable = true;
  tpm.enable = true;
}
