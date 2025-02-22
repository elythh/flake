{ pkgs, ... }:
{
  # nix
  documentation.nixos.enable = false;
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  # virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    podman.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
  };

  # dconf
  programs.dconf.enable = true;

  # shell
  programs.fish.enable = true;

  # packages
  environment.systemPackages = with pkgs; [
    home-manager
    git
    wget
  ];

  # services
  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
    };
    sysprof.enable = true;
    printing.enable = true;
    flatpak.enable = true;
    openssh.enable = true;
  };

  # network
  networking.networkmanager.enable = true;

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true; # bluetooth percentage
  };

  # bootloader
  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      timeout = 2;
      grub = {
        enable = true;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "24.11";
}
