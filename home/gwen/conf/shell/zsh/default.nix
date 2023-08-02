{ config, colors, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    envExtra = ''
      ZDOTDIR=${config.home.homeDirectory}/.config/zsh/
    '';
  };
  programs.starship = with colors;
    {
      enable = true;
      settings = {
        format = "$directory$git_branch$character";
        right_format = "$kubernetes$git_status$cmd_duration";
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

        conda = {
          format = " [ $symbol$environment ] (dimmed green) ";
        };
        character = {
          success_symbol = "[](#${color4} bold)";
          error_symbol = "[](#${color9})";
          vicmd_symbol = "[](#${color3})";
        };
        directory = {
          format = "[]($style)[  ](bg:#${bg2} fg:#${color4})[$path](bg:#${bg2} fg:#${color7} bold)[ ]($style)";
          style = "bg:none fg:#${bg2}";
          truncation_length = 3;
          truncate_to_repo = false;
        };
        git_branch = {
          format = "[]($style)[[  ](bg:#${bg2} fg:#${color12} bold)$branch](bg:#${bg2} fg:#${color7})[ ]($style)";
          style = "bg:none fg:#${bg2}";
        };
        git_status = {
          format = "[]($style)[$all_status$ahead_behind](bg:#${bg2} fg:#${color7})[ ]($style)";
          style = "bg:none fg:#${bg2}";
          conflicted = "=";
          ahead = "⇡\${count}";
          behind = "⇣\${count} ";
          diverged = "↑\${ahead_count} ⇣\${behind_count} ";
          up_to_date = "✓ ";
          untracked = "?\${count} ";
          stashed = " ";
          modified = "!\${count} ";
          staged = "+\${count} ";
          renamed = "»\${count} ";
          deleted = " \${count} ";
        };
        cmd_duration = {
          min_time = 1;
          # duration & style ;
          format = "[]($style)[[  ](bg:#${bg2} fg:#${color4} bold)$duration](bg:#${bg2} fg:#${color7})[ ]($style)";
          disabled = false;
          style = "bg:none fg:#${bg2}";
        };
        kubernetes = {
          format = "[](fg:#${bg2} bg:#${color2})[$context/$namespace]($style)[](fg:#${bg2} bg:#${color14})[](fg:#${bg2} bg:#${color15})[⎈](fg:#${bg2} bg:#${color4})[](fg:#${bg2} bg:#${color7}) ";
          disabled = false;
          style = "fg:#${bg2} bg:none";
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
}

























