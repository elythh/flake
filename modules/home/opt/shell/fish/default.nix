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
