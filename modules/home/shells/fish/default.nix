{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = builtins.elem "fish" config.meadow.default.shell;
in
{
  config = mkIf cfg {
    xdg.configFile."fish/functions" = {
      source = lib.cleanSourceWith { src = lib.cleanSource ./functions/.; };
      recursive = true;
    };

    home.sessionVariables = {
      STRUKTUR_PATH = "/home/sarw/workspace/rf/struktur/k8s";
    };
    home.packages = with pkgs; [ figlet ];

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
        kdecode = ''
          set secret (kubectl get secret | fzf -e | awk '{print $1}')
          kubectl get secret $secret -o json | jq '.data | map_values(@base64d) | .[]'
        '';
        last_history_item = ''
          echo $history[1]
        '';
        last_argument = ''
          set -l prev_command (history --max 1)

          if test -z "$prev_command"
              echo ""
              return
          end

          set -l args (string split " " "$prev_command")
          echo "$args[-1]"
        '';
      };
      shellAliases = with pkgs; {
        v = "nvim";
        ":q" = "exit";
        cat = "${bat}/bin/bat";
        du = "${du-dust}/bin/dust";
        g = "${gitAndTools.git}/bin/git";
        la = "ll -a";
        ll = "ls -l --time-style long-iso --icons";
        ls = "${eza}/bin/eza";
        tb = "toggle-background";

        tg = "TERRAGRUNT_PROVIDER_CACHE=1 TERRAGRUNT_PROVIDER_CACHE_DIR=~/.terraform.d/plugin-cache/ TERRAGRUNT_TFPATH=terraform terragrunt";
        tginfo = "TERRAGRUNT_PROVIDER_CACHE=1 TERRAGRUNT_PROVIDER_CACHE_DIR=~/.terraform.d/plugin-cache/ TERRAGRUNT_TFPATH=terraform terragrunt --terragrunt-debug";
        tgdebug = "TERRAGRUNT_PROVIDER_CACHE=1 TERRAGRUNT_PROVIDER_CACHE_DIR=~/.terraform.d/plugin-cache/ TERRAGRUNT_TFPATH=terraform TF_LOG=DEBUG terragrunt --terragrunt-debug";
        w = "wanda";

        k9s = "k9s --readonly";
        kns = "kubens";
        kcx = "kubectx";
        kubectl = "kubecolor";
        k = "kubectl";
        kg = "kubectl get";
        kd = "kubectl describe";
        kgp = "kubectl get pods";
        kgns = "kubectl get namespaces";
        kgi = "kubectl get ingress";
        kgall = "kubectl get ingress,service,deployment,pod,statefulset";
        kuc = "kubectl config use-context";
        kgc = "kubectl config get-contexts";
        kex = "kubectl exec -it";
        kl = "kubectl logs";
        kwatch = "kubectl get pods -w --all-namespaces";
      };
      shellAbbrs = {
        "!!" = {
          position = "anywhere";
          function = "last_history_item";
        };
        "'!$'" = {
          position = "anywhere";
          function = "last_argument";
        };
      };
      plugins = [
        {
          inherit (pkgs.fishPlugins.autopair) src;
          name = "autopair";
        }
        {
          inherit (pkgs.fishPlugins.plugin-git) src;
          name = "plugin-git";
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
        {
          inherit (pkgs.fishPlugins.fish-you-should-use) src;
          name = "fish-you-should-use";
        }
        # {
        #   inherit (pkgs.fishPlugins.bang-bang) src;
        #   name = "bang-bang";
        # }
        # {
        #   inherit (pkgs.fishPlugins.fzf) src;
        #   name = "fzf";
        # }
        # {
        #   inherit (pkgs.fishPlugins.fzf-fish) src;
        #   name = "fzf-fish";
        # }
      ];
      shellInitLast = ''
        export PATH="$STRUKTUR_PATH/bin:$PATH"
        export EDITOR=nvim
        status is-interactive; and begin
           enable_transience

           # Set QEMU=1 if we're in QEMU
           if command -q systemd-detect-virt; and [ $(systemd-detect-virt) = "qemu" ]
             set -x QEMU 1
           end
         end
        fish_config theme choose "Tomorrow Night"
        if uwsm check may-start && uwsm select; then
          exec uwsm start default
        end
      '';
    };
  };
}
