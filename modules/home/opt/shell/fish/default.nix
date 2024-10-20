{ lib, pkgs, ... }:
{

  xdg.configFile."fish/functions" = {
    source = lib.cleanSourceWith { src = lib.cleanSource ./functions/.; };
    recursive = true;
  };

  programs.fish = {
    enable = true;
    functions = {
      refresh = "source $HOME/.config/fish/config.fish";
      take = ''mkdir -p -- "$1" && cd -- "$1"'';
      ttake = "cd $(mktemp -d)";
      show_path = "echo $PATH | tr ' ' '\n'";
      posix-source = ''
        for i in (cat $argv)
          set arr (echo $i |tr = \n)
          set -gx $arr[1] $arr[2]
        end
      '';
    };
    shellAliases = with pkgs; {
      v = "nvim";
      ".." = "cd ..";
      ":q" = "exit";
      cat = "${bat}/bin/bat";
      du = "${du-dust}/bin/dust";
      g = "${gitAndTools.git}/bin/git";
      la = "ll -a";
      ll = "ls -l --time-style long-iso --icons";
      ls = "${eza}/bin/eza";
      tb = "toggle-background";
    };
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
      # {
      #   inherit (pkgs.fishPlugins.fzf) src;
      #   name = "fzf";
      # }
      {
        inherit (pkgs.fishPlugins.fzf-fish) src;
        name = "fzf-fish";
      }
    ];
  };
}
