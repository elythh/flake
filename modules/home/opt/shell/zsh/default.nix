{
  config,
  lib,
  ...
}: {
  imports = [./run-as-service.nix];

  config = lib.mkIf config.modules.zsh.enable {
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      envExtra = ''
        export PATH=~/.local/bin:~/.local/share/nvim/mason/bin:$PATH
      '';
      initExtra = ''
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

    programs.starship = with config.lib.stylix.colors; {
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
          success_symbol = "[ ](#${base03} bold)";
          error_symbol = "[ ](#${base04} bold)";
          vicmd_symbol = "[](#${base03})";
        };
        directory = {
          format = "[]($style)[  ](bg:#${base01} fg:#${base05})[$path](bg:#${base01} fg:#${base03} bold)[ ]($style)";
          style = "bg:none fg:#${base01}";
          truncation_length = 3;
          truncate_to_repo = false;
        };
        git_branch = {
          format = "[]($style)[[ ](bg:#${base01} fg:#${base05} bold)$branch](bg:#${base01} fg:#${base03} bold)[ ]($style)";
          style = "bg:none fg:#${base01}";
        };
        git_status = {
          format = "[]($style)[$all_status$ahead_behind](bg:#${base01} fg:#${base03} bold)[ ]($style)";
          style = "bg:none fg:#${base01}";
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
          format = "[]($style)[[  ](bg:#${base01} fg:#${base05} bold)$duration](bg:#${base01} fg:#${base03} bold)[]($style)";
          disabled = false;
          style = "bg:none fg:#${base01}";
        };
        nix_shell = {
          disabled = false;
          heuristic = false;
          format = "[]($style)[ ](bg:#${base01} fg:#${base05} bold)[]($style)";
          style = "bg:none fg:#${base01}";
          impure_msg = "";
          pure_msg = "";
          unknown_msg = "";
        };
        kubernetes = {
          format = "[](fg:#${base01} bg:none)[  ](fg:#${base05} bg:#${base01})[$context/$namespace]($style)[](fg:#${base01} bg:none) ";
          disabled = false;
          style = "fg:#${base03} bg:#${base01} bold";
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
