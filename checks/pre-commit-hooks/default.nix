{
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (inputs) pre-commit-hooks;
  inherit (lib) getExe;
in
pre-commit-hooks.lib.${pkgs.system}.run {
  src = ./.;
  hooks =
    let
      excludes = [
        "flake.lock"
        "CHANGELOG.md"
      ];
      fail_fast = true;
      verbose = true;
    in
    {
      actionlint.enable = true;
      # conform.enable = true;

      deadnix = {
        enable = true;

        settings = {
          edit = true;
        };
      };

      git-cliff = {
        enable = false;
        inherit excludes fail_fast verbose;

        always_run = true;
        description = "pre-push hook for git-cliff";
        entry = "${getExe pkgs.${namespace}.git-cliff}";
        language = "system";
        stages = [ "pre-push" ];
      };

      nixfmt = {
        enable = true;
        package = pkgs.nixfmt-rfc-style;
      };

      pre-commit-hook-ensure-sops.enable = true;

      shfmt = {
        enable = true;

        excludes = [ ".*.p10k.zsh$" ];
      };

      statix.enable = true;
    };
}
