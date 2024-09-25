{ config, inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = {
    sops = {
      defaultSopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      defaultSopsFormat = "yaml";

      age = {
        generateKey = true;
        keyFile = "/home/gwen/.config/sops/age/keys.txt";
        sshKeyPaths = [ "/home/gwen/.ssh/id_ed25519" ];
      };
    };
  };
}
