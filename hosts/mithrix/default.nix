{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  hostname = "mithrix";
in
{
  imports = [
    inputs.grub2-themes.nixosModules.default

    ./hardware-configuration.nix
    ./docker-compose.nix
  ];

  services.xserver.enable = lib.mkForce false;
  opt = {
    services = {
      your_spotify.enable = true;
    };
  };
  tailscale.enable = true;

  networking.hostName = hostname;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    # mithrix = {
    #   isNormalUser = true;
    #   extraGroups = [
    #     "wheel"
    #     "docker"
    #   ]; # Enable ‘sudo’ for the user.
    #
    #   packages = with pkgs; [
    #     tree
    #     git
    #     lazydocker
    #     nh
    #   ];
    # };
    gwen = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ]; # Enable ‘sudo’ for the user.

      packages = with pkgs; [
        tree
        git
        kubectl
        nh
        starship
        eza
        inputs.nixvim.packages."x86_64-linux".default
      ];
    };
  };
  virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  system.stateVersion = "24.05"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "gwen" ];
}
