{ inputs, ... }:
{
  imports = [
    inputs.hm.nixosModules.default
    inputs.grub2-themes.nixosModules.default
    inputs.impermanence.nixosModules.impermanence

    ./hardware.nix
  ];
  networking.hostName = "grovetender"; # Define your hostname.

  meadow = {
    programs = {
      tailscale.enable = true;
      wayland.enable = true;
      steam.enable = false;
    };
    services = {
      pipewire.enable = true;
      tpm.enable = true;
      wireguard.enable = false;
      kanata.enable = true;
    };
    impermanence.enable = true;
  };
}
