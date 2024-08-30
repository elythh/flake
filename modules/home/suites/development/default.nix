{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.development;
in
{
  options.${namespace}.suites.development = {
    enable = mkBoolOpt false "Whether or not to enable common development configuration.";
    dockerEnable = mkBoolOpt false "Whether or not to enable docker development configuration.";
    kubernetesEnable = mkBoolOpt false "Whether or not to enable kubernetes development configuration.";
    nixEnable = mkBoolOpt false "Whether or not to enable nix development configuration.";
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        with pkgs;
        [
          jqp
          onefetch
          postman
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          github-desktop
          qtcreator
        ]
        ++ lib.optionals cfg.nixEnable [
          nixpkgs-hammering
          nixpkgs-lint-community
          nixpkgs-review
          nix-update
        ];

      shellAliases = {
        prefetch-sri = "nix store prefetch-file $1";
      };
    };

    elyth = {
      programs = {
        terminal = {
          editors = {
            # helix = enabled;
            neovim = {
              enable = true;
              default = true;
            };
          };

          tools = {
            git-crypt = enabled;
            k9s.enable = cfg.kubernetesEnable;
            lazydocker.enable = cfg.dockerEnable;
            lazygit = enabled;
            # oh-my-posh = enabled;
            # FIXME: broken nixpkg
            # prisma = enabled;
          };
        };
      };
    };
  };
}
