{ inputs, ... }:
{
  imports = [ inputs.pre-commit-hooks.flakeModule ];

  perSystem.pre-commit = {
    settings.excludes = [ "flake.lock" ];

    settings.hooks = {
      deadnix.enable = true;
      flake-checker.enable = true;
      nil.enable = true;
      nixfmt-rfc-style.enable = true;
    };
  };
}
