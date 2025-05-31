{ inputs, ... }:
{
  imports = [
    inputs.hm.nixosModules.default
    inputs.grub2-themes.nixosModules.default

    ./hardware.nix
  ];
  networking.hostName = "aurelionite"; # Define your hostname.

  meadow = {
    programs = {
      tailscale.enable = true;
      wayland.enable = true;
      steam.enable = false;
    };
    services = {
      pipewire.enable = true;
      tpm.enable = true;
    };
  };
}
