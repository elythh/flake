{ inputs, ... }:
{
  imports = [
    inputs.hm.nixosModules.default
    inputs.grub2-themes.nixosModules.default
    inputs.impermanence.nixosModules.impermanence

    ./hardware.nix
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
