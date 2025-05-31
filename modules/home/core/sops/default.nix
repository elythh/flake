{
  config,
  inputs,
  ...
}: {
  imports = [inputs.sops-nix.homeManagerModules.sops];

  config = {
    sops = {
      defaultSopsFile = "${inputs.self}/secrets/gwen/secrets.yaml";
      defaultSopsFormat = "yaml";

      age = {
        generateKey = true;
        keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_default"];
      };
    };
  };
}
