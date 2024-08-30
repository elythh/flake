{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt default-attrs;

  cfg = config.${namespace}.system.boot;
in
{
  options.${namespace}.system.boot = {
    enable = mkBoolOpt false "Whether or not to enable booting.";
    silentBoot = mkBoolOpt false "Whether or not to enable silent boot.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      efibootmgr
      efitools
      efivar
      fwupd
    ];

    boot = {
      kernelParams = lib.optionals cfg.silentBoot [
        # tell the kernel to not be verbose
        "quiet"

        # kernel log message level
        "loglevel=3" # 1: system is unusable | 3: error condition | 7: very verbose

        # udev log message level
        "udev.log_level=3"

        # lower the udev log level to show only errors or worse
        "rd.udev.log_level=3"

        # disable systemd status messages
        # rd prefix means systemd-udev will be used instead of initrd
        "systemd.show_status=auto"
        "rd.systemd.show_status=auto"

        # disable the cursor in vt to get a black screen during intermissions
        "vt.global_cursor_default=0"
      ];

      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        grub = {
          enable = true;
          useOSProber = true;
          efiSupport = true;
          device = "nodev";
        };

        generationsDir.copyKernels = true;

        # systemd-boot = {
        #   enable = true;
        #   configurationLimit = 20;
        #   editor = false;
        # };
      };

      tmp = default-attrs {
        useTmpfs = true;
        cleanOnBoot = true;
        tmpfsSize = "50%";
      };
    };

    services.fwupd = {
      enable = true;
      daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
    };
  };
}
