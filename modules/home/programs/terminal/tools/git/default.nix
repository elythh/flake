{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    types
    mkEnableOption
    mkIf
    mkForce
    ;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.programs.terminal.tools.git;

  aliases = import ./aliases.nix;
  ignores = import ./ignores.nix;
in
{
  options.${namespace}.programs.terminal.tools.git = {
    enable = mkEnableOption "Git";
    includes = mkOpt (types.listOf types.attrs) [ ] "Git includeIf paths and conditions.";
    signByDefault = mkOpt types.bool true "Whether to sign commits by default.";
    signingKey =
      mkOpt types.str "${config.home.homeDirectory}/.ssh/id_ed25519"
        "The key ID to sign commits with.";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
    wslAgentBridge = mkBoolOpt false "Whether to enable the wsl agent bridge.";
    wslGitCredentialManagerPath =
      mkOpt types.str "/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe"
        "The windows git credential manager path.";
    _1password = mkBoolOpt false "Whether to enable 1Password integration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bfg-repo-cleaner
      git-crypt
      git-filter-repo
      git-lfs
      gitflow
      gitleaks
      gitlint
    ];

    programs = {
      git = {
        enable = true;
        package = pkgs.gitFull;
        inherit (cfg) includes userName userEmail;
        inherit (aliases) aliases;
        inherit (ignores) ignores;

        delta = {
          enable = true;

          options = {
            dark = true;
            features = mkForce "decorations side-by-side navigate";
            line-numbers = true;
            navigate = true;
            side-by-side = true;
          };
        };

        signing = {
          key = cfg.signingKey;
          inherit (cfg) signByDefault;
        };
      };

      gh = {
        enable = true;

        extensions = with pkgs; [
          gh-dash # dashboard with pull requests and issues
          gh-eco # explore the ecosystem
          gh-cal # contributions calender terminal viewer
          gh-poi # clean up local branches safely
        ];

        gitCredentialHelper = {
          enable = true;
          hosts = [
            "https://github.com"
            "https://gist.github.com"
            "https://dibc@dev.azure.com"
            "https://core-bts-02@dev.azure.com"
          ];
        };

        settings = {
          version = "1";
        };
      };

      bash.initExtra = # bash
        ''
          export GITHUB_TOKEN="$(cat ${config.sops.secrets."github/access-token".path})"
        '';
      fish.shellInit = # fish
        ''
          export GITHUB_TOKEN="(cat ${config.sops.secrets."github/access-token".path})"
        '';
      zsh.initExtra = # bash
        ''
          export GITHUB_TOKEN="$(cat ${config.sops.secrets."github/access-token".path})"
        '';
    };

    home = {
      inherit (aliases) shellAliases;
    };

    sops.secrets = {
      "github/access-token" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/gwen/secrets.yaml";
        path = "${config.home.homeDirectory}/.config/gh/access-token";
      };
    };
  };
}
