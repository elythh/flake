{
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
    # ./docker-compose.nix
  ];
  networking.hostName = hostname;

  opt = {
    services = {
      your_spotify.enable = true;
      immich.enable = true;
      cloudflared-tunnel.enable = true;
      vikunja.enable = true;
      glance.enable = true;
      paperless.enable = true;
      #radicle.enable = true;
      soft-serve.enable = true;
    };
  };
  tailscale.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    gwen = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsZ/9N72VrtwfZVklSPgaDTLSSRYVlP1l+7cDZwIj6v gwenchlan.lekerneau@radiofrance.co m - default key"
      ];
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

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };
  system.stateVersion = "24.05"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "gwen" ];
}
