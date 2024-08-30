{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;
in
{
  imports = [
    ./hardware.nix
  ];
  elyth = {
    nix = enabled;

    archetypes = {
      personal = enabled;
      workstation = enabled;
    };

    display-managers = {
      regreet = {
        hyprlandOutput = builtins.readFile ./hyprlandOutput;
      };
    };

    hardware = {
      audio = {
        enable = true;
      };
      bluetooth = enabled;
      cpu.amd = enabled;
      opengl = enabled;
    };

    programs = {
      graphical = {
        addons = {
          noisetorch = {
            enable = false;

            threshold = 95;
            device = "alsa_input.usb-Blue_Microphones_Yeti_Stereo_Microphone_LT_191128065321F39907D0_111000-00.analog-stereo";
            deviceUnit = "sys-devices-pci0000:00-0000:00:01.2-0000:02:00.0-0000:03:08.0-0000:08:00.3-usb3-3\x2d2-3\x2d2.1-3\x2d2.1.4-3\x2d2.1.4.3-3\x2d2.1.4.3:1.0-sound-card3-controlC3.device";
          };
        };

        wms = {
          hyprland = {
            enable = true;
          };
        };
      };
    };

    services = {
      power = enabled;

      openssh = {
        enable = true;

        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP8Uvx1a/dkacYXKXDikaFL6kfRk+kSj6n7Pwm9t6+HP"
        ];

        # TODO: make part of ssh config proper
        extraConfig = ''
          Host server
            User ${config.${namespace}.user.name}
            Hostname elyth.local
        '';
      };
    };

    security = {
      # doas = enabled;
      keyring = enabled;
      sudo-rs = enabled;
    };

    suites = {
      development = {
        enable = true;
        dockerEnable = true;
        kubernetesEnable = true;
        nixEnable = true;
      };
    };

    system = {
      boot = {
        enable = true;
        silentBoot = true;
      };

      fonts = enabled;
      locale = enabled;
      networking = {
        enable = true;
        optimizeTcp = true;
      };
      time = enabled;
    };

    theme = {
      qt = enabled;
      gtk = enabled;
    };
  };

  nix.settings = {
    cores = 24;
    max-jobs = 24;
  };

  services = {
    displayManager.defaultSession = "hyprland";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
