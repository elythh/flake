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
  services.xserver.enable = false;
  services.jellyfin.enable = true;

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
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpPIAxkCw3MXGb/XOdbduOkbD6dEHGiVl9lfjIXQ0I6qKDlKDdoAFIcpsiU5meAcsG9D0Mw5BwIkhUmIiKz2LNJaDX3ef3oiKyGHob7/Lb8Bves8jktKXBXrV3saooQlqVb1lMVoE4AYzWz3UK/QEQQvCQlSw2cTTjGJbf8Ri7nbyvihg3ndUjKDOeQ8sBcNaPhg3DlUaks35nGWrAs8XbRGj51nR4W2h5LwE2odPgUPRwBlZEyTCayBudzS4tXUIV/DtMaojTrPpdhcOPOQfGNrfyM09XgfzFCppz9zGvva/Yrl6efxs4wAbSPyKFqef+PQn2EgswimRkXPRr0GWLL+ntQturch7YhApz5gxUhrwnTSC8of25CJn4h0qLPb4k9M91Eeje5vVSqgci/UkdAX99IkDhYaEdils+CbaeIXL70xmKFd+RYvmr3hMHPQQrRhYAaAxdncwXnsQa5Gxk75DrPk//TD6DFaESARoruPmcSh/mujpvBV/H5NssACM= gwen@thinkpad"
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
