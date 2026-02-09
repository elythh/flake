{
  boot = {
    kernel.sysctl."net.isoc" = true;
    loader = {
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        device = "nodev";
        extraEntriesBeforeNixOS = true;
        efiInstallAsRemovable = true;
      };
      #systemd-boot.enable = true;
      # efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
  };
}
