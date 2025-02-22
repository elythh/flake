{
  pkgs,
  config,
  lib,
  ...
}:
let
  aliases = {
    "db" = "distrobox";
    "tree" = "eza --tree";
    "v" = "nvim";

    "ll" =
      "eza -la --sort name --group-directories-first --no-permissions --no-filesize --no-user --no-time";

    "éé" = "ls";
    "és" = "ls";
    "l" = "ls";

    ":q" = "exit";
    "q" = "exit";

    "gs" = "git status";
    "gb" = "git branch";
    "gch" = "git checkout";
    "gc" = "git commit";
    "ga" = "git add";
    "gr" = "git reset --soft HEAD~1";

    "del" = "gio trash";
    "dev" = "nix develop -c nvim";
  };
in
{
  options.shellAliases =
    with lib;
    mkOption {
      type = types.attrsOf types.str;
      default = { };
    };

  config = {
    programs = {
      zsh = {
        shellAliases = aliases // config.shellAliases;
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        initExtra = ''
          SHELL=${pkgs.zsh}/bin/zsh
          zstyle ':completion:*' menu select
          bindkey "^[[1;5C" forward-word
          bindkey "^[[1;5D" backward-word
          unsetopt BEEP
        '';
      };

      bash = {
        shellAliases = aliases // config.shellAliases;
        enable = true;
        initExtra = "SHELL=${pkgs.bash}";
      };

      nushell = {
        shellAliases = aliases // config.shellAliases;
        enable = true;
        environmentVariables = {
          PROMPT_INDICATOR_VI_INSERT = "  ";
          PROMPT_INDICATOR_VI_NORMAL = "∙ ";
          PROMPT_COMMAND = "";
          PROMPT_COMMAND_RIGHT = "";
          NIXPKGS_ALLOW_UNFREE = "1";
          NIXPKGS_ALLOW_INSECURE = "1";
          SHELL = "${pkgs.nushell}/bin/nu";
          inherit (config.home.sessionVariables) EDITOR;
          # VISUAL = config.home.sessionVariables.VISUAL;
        };
        extraConfig =
          let
            conf = builtins.toJSON {
              show_banner = false;
              edit_mode = "vi";

              ls.clickable_links = true;
              rm.always_trash = true;

              table = {
                mode = "compact"; # compact thin rounded
                index_mode = "always"; # alway never auto
                header_on_separator = false;
              };

              cursor_shape = {
                vi_insert = "line";
                vi_normal = "block";
              };

              display_errors = {
                exit_code = false;
              };

              menus = [
                {
                  name = "completion_menu";
                  only_buffer_difference = false;
                  marker = "? ";
                  type = {
                    layout = "columnar"; # list, description
                    columns = 4;
                    col_padding = 2;
                  };
                  style = {
                    text = "magenta";
                    selected_text = "blue_reverse";
                    description_text = "yellow";
                  };
                }
              ];
            };
            completions =
              let
                completion = name: ''
                  source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
                '';
              in
              names: builtins.foldl' (prev: str: "${prev}\n${str}") "" (map completion names);
          in
          ''
            $env.config = ${conf};
            ${completions [
              "cargo"
              "git"
              "nix"
              "npm"
              "curl"
            ]}

            # alias pueue = ${pkgs.pueue}/bin/pueue
            # alias pueued = ${pkgs.pueue}/bin/pueued
            # use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/task.nu
            source ${pkgs.nu_scripts}/share/nu_scripts/modules/formats/from-env.nu
            use ${../scripts}/blocks.nu

            const path = "~/.nushellrc.nu"
            const null = "/dev/null"
            source (if ($path | path exists) {
                $path
            } else {
                $null
            })
          '';
      };

      fish = {
        shellAliases = aliases // config.shellAliases;
        enable = true;
        plugins = [
          {
            inherit (pkgs.fishPlugins.autopair) src;
            name = "autopair";
          }
          {
            inherit (pkgs.fishPlugins.done) src;
            name = "done";
          }
          {
            inherit (pkgs.fishPlugins.fifc) src;
            name = "fifc";
          }
          {
            inherit (pkgs.fishPlugins.sponge) src;
            name = "sponge";
          }
          {
            inherit (pkgs.fishPlugins.z) src;
            name = "z";
          }
        ];
        shellInitLast = ''
          export PATH="$STRUKTUR_PATH/bin:$PATH"
          status is-interactive; and begin
             enable_transience
             tv init fish | source

             # Set QEMU=1 if we're in QEMU
             if command -q systemd-detect-virt; and [ $(systemd-detect-virt) = "qemu" ]
               set -x QEMU 1
             end
           end
          fish_config theme choose "Tomorrow Night"
        '';
      };

    };
  };
}
