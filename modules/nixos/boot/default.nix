{
  boot = {
    kernel.sysctl."net.isoc" = true;
    loader = {
      grub2-theme = {
        enable = true;
        theme = "vimix";
        footer = true;
      };
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        device = "nodev";
      };
      #systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
  };
}
