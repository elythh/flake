{ inputs, ... }:
let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in
{
  imports = [ inputs.pre-commit-hooks.flakeModule ];

  perSystem.pre-commit = {
    settings.excludes = [ "flake.lock" ];

    settings.hooks = {
      nixfmt.enable = true;
      nixfmt.package = pkgs.nixfmt-rfc-style;
    };
  };
}
