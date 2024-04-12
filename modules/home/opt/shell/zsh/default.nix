{
  config,
  lib,
  ...
}: {
  imports = [./run-as-service.nix];

  config = lib.mkIf config.modules.zsh.enable {
    programs.zsh = with config.colorscheme.palette; {
      enable = true;
      dotDir = ".config/zsh";
      envExtra = ''
        export PATH=~/.local/bin:~/.local/share/nvim/mason/bin:$PATH
      '';
      initExtra = ''
        background="#${background}"
        foreground="#${foreground}"
        mbg="#${mbg}"
        darker="#${darker}"
        accent="#${accent}"

        # Black
        color0="#${color0}"
        color8="#${color0}"

        # Red
        color1="#${color1}"
        color9="#${color9}"

        # Green
        color2="#${color2}"
        color10="#${color10}"

        # Yellow
        color3="#${color3}"
        color11="#${color11}"

        # Blue
        color4="#${color4}"
        color12="#${color12}"

        # Magenta
        color5="#${color5}"
        color13="#${color13}"

        # Cyan
        color6="#${color6}"
        color14="#${color14}"
        # White
        color7="#${color7}"
        color15="#${color15}"

        source ~/.config/zsh/env.zsh
        source ~/.config/zsh/aliases.zsh
        source ~/.config/zsh/options.zsh
        source ~/.config/zsh/plugins.zsh
        source ~/.config/zsh/utility.zsh
        source ~/.config/zsh/keybinds.zsh
      '';
    };
    home.file.kubie = {
      target = ".kube/kubie.yaml";
      text = ''
        prompt:
          disable: true
      '';
    };

    programs.starship = with config.colorscheme.palette; {
      enable = true;
      settings = {
        format = "$directory$nix_shell$fill$git_branch$kubernetes$git_status$cmd_duration$line_break$character";
        add_newline = false;
        c.disabled = true;
        cmake.disabled = true;
        haskell.disabled = true;
        python.disabled = true;
        ruby.disabled = true;
        rust.disabled = true;
        perl.disabled = true;
        package.disabled = true;
        lua.disabled = true;
        nodejs.disabled = true;
        java.disabled = true;
        golang.disabled = true;

        fill = {symbol = " ";};
        conda = {format = " [ $symbol$environment ] (dimmed green) ";};
        character = {
          success_symbol = "[ ](#${accent} bold)";
          error_symbol = "[ ](#${color1} bold)";
          vicmd_symbol = "[](#${color3})";
        };
        directory = {
          format = "[]($style)[  ](bg:#${darker} fg:#${accent})[$path](bg:#${darker} fg:#${color7} bold)[ ]($style)";
          style = "bg:none fg:#${darker}";
          truncation_length = 3;
          truncate_to_repo = false;
        };
        git_branch = {
          format = "[]($style)[[ ](bg:#${darker} fg:#${accent} bold)$branch](bg:#${darker} fg:#${color7} bold)[ ]($style)";
          style = "bg:none fg:#${darker}";
        };
        git_status = {
          format = "[]($style)[$all_status$ahead_behind](bg:#${darker} fg:#${color7} bold)[ ]($style)";
          style = "bg:none fg:#${darker}";
          conflicted = "=";
          ahead = "⇡\${count}";
          behind = "⇣\${count} ";
          diverged = "↑\${ahead_count} ⇣\${behind_count} ";
          up_to_date = " ";
          untracked = "?\${count} ";
          stashed = "󰥔 ";
          modified = "!\${count} ";
          staged = "+\${count} ";
          renamed = "»\${count} ";
          deleted = " \${count} ";
        };
        cmd_duration = {
          min_time = 1;
          # duration & style ;
          format = "[]($style)[[  ](bg:#${darker} fg:#${accent} bold)$duration](bg:#${darker} fg:#${color7} bold)[]($style)";
          disabled = false;
          style = "bg:none fg:#${darker}";
        };
        nix_shell = {
          disabled = false;
          heuristic = false;
          format = "[ ](bg:#${darker} fg:#${accent} bold)";
          impure_msg = "";
          pure_msg = "";
          unknown_msg = "";
        };
        kubernetes = {
          format = "[](fg:#${darker} bg:none)[  ](fg:#${accent} bg:#${darker})[$context/$namespace]($style)[](fg:#${darker} bg:none) ";
          disabled = false;
          style = "fg:#${color7} bg:#${darker} bold";
          context_aliases = {
            "dev.local.cluster.k8s" = "dev";
            ".*/openshift-cluster/.*" = "openshift";
            "gke_.*_(?P<var_cluster>[\\w-]+)" = "gke-$var_cluster";
          };
          user_aliases = {
            "dev.local.cluster.k8s" = "dev";
            "root/.*" = "root";
          };
        };
      };
    };
  };
}
