_:

let

  colors = scheme: {
    background = scheme.bg;
    foreground = scheme.fg;
    cursor_bg = scheme.cursor.bg;
    cursor_fg = scheme.cursor.fg;
    cursor_border = scheme.fg;
    selection_fg = scheme.selection.fg;
    selection_bg = scheme.selection.fg;
    scrollbar_thumb = scheme.fg;
    split = scheme.white;
    inherit (scheme)
      bg
      fg
      black
      red
      green
      yellow
      blue
      magenta
      cyan
      white
      orange
      ;

  };
in
{
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      palette = "default";
      palettes = {
        "default" = colors (import ./colors.nix { scheme = "dark"; });
      };
      format = "$directory$nix_shell$fill$git_branch$azure$gcloud$kubernetes$git_status$cmd_duration$line_break$character";
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
        success_symbol = "[ ](green bold)";
        error_symbol = "[ ](red bold)";
        vicmd_symbol = "[ ](orange)";
      };
      directory = {
        format = "[]($style)[ ](bg:selection_bg fg:white)[$path](bg:selection_bg fg:white bold)[ ]($style)";
        style = "bg:none fg:selection_fg";
        truncation_length = 3;
        truncate_to_repo = false;
      };
      git_branch = {
        format = "[]($style)[[ ](bg:selection_bg fg:cyan bold)$branch](bg:selection_bg fg:white bold)[ ]($style)";
        style = "bg:none fg:selection_fg";
      };
      git_status = {
        format = "[]($style)[$all_status$ahead_behind](bg:selection_bg fg:white bold)[ ]($style)";
        style = "bg:none fg:selection_fg";
        conflicted = "=";
        ahead = "[⇡\${count} ](fg:magenta bg:selection_bg) ";
        behind = "[⇣\${count} ](fg:red bg:selection_bg)";
        diverged = "↑\${ahead_count} ⇣\${behind_count} ";
        up_to_date = "[](fg:magenta bg:selection_bg)";
        untracked = "[?\${count} ](fg:black bg:selection_bg) ";
        stashed = "";
        modified = "[~\${count} ](fg:orange bg:selection_bg)";
        staged = "[+\${count} ](fg:magenta bg:selection_bg) ";
        renamed = "[󰑕\${count} ](fg:orange bg:selection_bg)";
        deleted = "[ \${count} ](fg:red bg:selection_bg) ";
      };
      cmd_duration = {
        min_time = 1;
        # duration & style ;
        format = "[]($style)[[ ](bg:selection_bg fg:red bold)$duration](bg:selection_bg fg:white bold)[]($style)";
        disabled = false;
        style = "bg:none fg:selection_fg";
      };
      nix_shell = {
        disabled = false;
        heuristic = false;
        format = "[]($style)[ ](bg:bg fg:fg bold)[]($style)";
        style = "bg:none fg:selection_fg";
        impure_msg = "";
        pure_msg = "";
        unknown_msg = "";
      };

      kubernetes = {
        format = "[]($style)[ ](fg:orange bg:bg)[$context/$namespace](bg:selection_bg fg:white bold)[]($style) ";
        disabled = false;
        style = "bg:none fg:selection_fg";
        context_aliases = {
          "dev.local.cluster.k8s" = "dev";
        };
        user_aliases = {
          "dev.local.cluster.k8s" = "dev";
          "root/.*" = "root";
        };
      };
      gcloud = {
        format = "[]($style)[  ](fg:red bg:selection_bg)[$project](bg:selection_bg fg:white bold)[]($style) ";
        style = "bg:none fg:selection_fg";
        disabled = false;
      };
      azure = {
        format = "[]($style)[󰠅 ](fg:blue bg:selection_bg)[$subscription](fg:white bg:selection_bg)[]($style) ";
        style = "bg:none fg:selection_fg";
        disabled = false;
      };
    };
  };
}
