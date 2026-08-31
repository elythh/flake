{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    kernel.sysctl."net.isoc" = true;
    loader = {
      # Lanzaboote replaces the systemd-boot module.
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      # Boot entries are content-addressed and ~100 MiB each, so cap how many
      # generations are kept on the ESP. Raise this if /boot is large.
      configurationLimit = 8;
    };
  };

  environment.systemPackages = [
    pkgs.sbctl # for debugging and troubleshooting Secure Boot
  ];
}
