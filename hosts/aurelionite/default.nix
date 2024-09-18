{ inputs, ... }:
{
  imports = [
    inputs.hm.nixosModule
    inputs.grub2-themes.nixosModules.default

    ./hardware-configuration.nix
  ];
  networking.hostName = "aurelionite"; # Define your hostname.

  tailscale.enable = true;
  fonts.enable = true;
  wayland.enable = true;
  pipewire.enable = true;
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  users.users.gwen.extraGroups = [ "tss" ]; # tss group has access to TPM devices
}
