{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = {
    sops = {
      defaultSopsFile = "${inputs.self}/secrets/${config.networking.hostName}/secrets.yaml";
      defaultSopsFormat = "yaml";

      age = {
        generateKey = true;
        keyFile = "/var/lib/sops-nix/keys.txt";
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };
    };
  };
}
