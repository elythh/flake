{ config, nix-colors, pkgs, ... }:
{
  programs.zsh = with config.colorScheme.colors;{
    enable = true;
    dotDir = ".config/zsh";
    envExtra = ''
      export PATH=~/.local/bin:~/.local/share/nvim/mason/bin:$PATH
    '';
    initExtra = ''
      background="#${base00}"
      foreground="#${base04}"
      mbg="#${base01}"
      darker="#${base00}"
      cursor="#${base08}"

      # Black
      color0="#${base00}"
      color8="#${base08}"

      # Red
      color1="#${base01}"
      color9="#${base09}"

      # Green
      color2="#${base02}"
      color10="#${base0A}"

      # Yellow
      color3="#${base03}"
      color11="#${base0B}"

      # Blue
      color4="#${base04}"
      color12="#${base0C}"

      # Magenta
      color5="#${base05}"
      color13="#${base0D}"

      # Cyan
      color6="#${base06}"
      color14="#${base0E}"
      # White
      color7="#${base07}"
      color15="#${base0F}"

      while read file
      do 
        source "$ZDOTDIR/$file.zsh"
      done <<-EOF
      env
      aliases
      utility
      options
      plugins
      keybinds
      EOF

    '';
  };

  programs.starship = with config.colorScheme.colors; {
    enable = true;
    settings = {
      format = "$directory$fill$git_branch$kubernetes$git_status$cmd_duration$line_break$character";
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

      fill = {
        symbol = " ";
      };
      conda = {
        format = " [ $symbol$environment ] (dimmed green) ";
      };
      character = {
        success_symbol = "[](#${base04} bold)";
        error_symbol = "[](#${base09} bold)";
        vicmd_symbol = "[](#${base03})";
      };
      directory = {
        format = "[]($style)[  ](bg:#${base04} fg:#${base05})[$path](bg:#${base04} fg:#${base07} bold)[ ]($style)";
        style = "bg:none fg:#${base04}";
        truncation_length = 3;
        truncate_to_repo = false;
      };
      git_branch = {
        format = "[]($style)[[  ](bg:#${base04} fg:#${base0C} bold)$branch](bg:#${base04} fg:#${base07} bold)[ ]($style)";
        style = "bg:none fg:#${base04}";
      };
      git_status = {
        format = "[]($style)[$all_status$ahead_behind](bg:#${base04} fg:#${base07} bold)[ ]($style)";
        style = "bg:none fg:#${base04}";
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count} ";
        diverged = "↑\${ahead_count} ⇣\${behind_count} ";
        up_to_date = " ";
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
        format = "[]($style)[[  ](bg:#${base04} fg:#${base0C} bold)$duration](bg:#${base04} fg:#${base07} bold)[]($style)";
        disabled = false;
        style = "bg:none fg:#${base04}";
      };
      kubernetes = {
        format = "[](fg:#${base04} bg:none)[  ](fg:#${base0C} bg:#${base04})[$context/$namespace]($style)[](fg:#${base04} bg:none) ";
        disabled = false;
        style = "fg:#${base07} bg:#${base04} bold";
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

























