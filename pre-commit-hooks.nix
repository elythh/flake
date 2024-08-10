{ inputs, ... }:
let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in
{
  imports = [ inputs.pre-commit-hooks.flakeModule ];

  perSystem.pre-commit = {
    settings.excludes = [ "flake.lock" ];

    settings.hooks = {
      deadnix.enable = true;
      flake-checker.enable = true;
      nil.enable = true;
      nixfmt = {
        enable = true;
        package = pkgs.nixfmt-rfc-style;
      };
    };
  };
}
