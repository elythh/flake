{ pkgs, ... }:
let
  hostname = "mithrix";
in
{
  imports = [
    ./hardware-configuration.nix
    ./docker-compose.nix
  ];
  networking.hostName = hostname;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    mithrix = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ]; # Enable ‘sudo’ for the user.

      packages = with pkgs; [
        tree
        neovim
        git
        lazydocker
        nh
      ];
    };
    gwen = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDhjgl7IPOvAP/pv8o1hnmSYE2ccN7IqMaGI3a3PYJT homelab - default key"
      ];

      packages = with pkgs; [
        tree
        neovim
        git
        kubectl
        nh
      ];
    };
  };
  virtualisation.docker.enable = true;
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "gwen" ];
}
