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

    ./hardware.nix
    # ./docker-compose.nix
  ];
  networking.hostName = hostname;

  opt = {
    services = {
      # your_spotify.enable = true;
      immich.enable = true;
      cloudflared-tunnel.enable = true;
      vikunja.enable = false;
      glance.enable = true;
      paperless.enable = true;
      #radicle.enable = true;
      soft-serve.enable = true;
      pingvin-share.enable = true;
    };
  };
  tailscale.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    gwen = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJUau5cBGOp4nM64CTEiVHO5/86OoC2rfXDsA3sgW5s"
      ];
      packages = with pkgs; [
        tree
        git
        kubectl
        nh
        starship
        eza
        inputs.neovim.packages."x86_64-linux".default
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
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "gwen" ];
}
