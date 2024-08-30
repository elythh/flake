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

  cfg = config.${namespace}.suites.common;
in
{
  options.${namespace}.suites.common = {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      nixcfg = "nvim ~/${namespace}/flake.nix";
    };

    home.packages =
      with pkgs;
      lib.optionals pkgs.stdenv.isLinux [
        ncdu
        toilet
        tree
      ];

    elyth = {
      programs = {
        graphical = {
          browsers = {
            firefox = enabled;
          };
        };

        terminal = {
          emulators = {
            foot = enabled;
          };

          shell = {
            bash = enabled;
            zsh = enabled;
          };

          tools = {
            bat = enabled;
            bottom = enabled;
            btop = enabled;
            colorls = enabled;
            comma = enabled;
            direnv = enabled;
            eza = enabled;
            fastfetch = enabled;
            fzf = enabled;
            fup-repl = enabled;
            git = enabled;
            jq = enabled;
            lsd = enabled;
            ripgrep = enabled;
            topgrade = enabled;
            zellij = enabled;
            zoxide = enabled;
          };
        };
      };

      services = {
        tray.enable = pkgs.stdenv.isLinux;
      };
    };

    programs.readline = {
      enable = true;

      extraConfig = ''
        set completion-ignore-case on
      '';
    };

    xdg.configFile.wgetrc.text = "";
  };
}
