{ lib, ... }:
{
  options.meadow.programs.shell = lib.mkOption {
    type = lib.types.enum [
      "none"
      "noctalia"
      "dank-material-shell"
    ];
    default = "none";
    description = "Desktop shell to activate.";
  };

  imports = lib.meadow.readSubdirs ./.;

  config = {
    programs = {
      direnv = {
        silent = true;
        enable = true;
        enableBashIntegration = true; # see note on other shells below
        nix-direnv.enable = true;
      };
      bash.enable = true;
      man.enable = false;
    };
  };
}
