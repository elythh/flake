{ lib, pkgs, ... }:
{

  xdg.configFile."fish/functions" = {
    source = lib.cleanSourceWith { src = lib.cleanSource ./functions/.; };
    recursive = true;
  };

  home.sessionVariables = {
    STRUKTUR_PATH = "/home/gwen/workspace/rf/struktur/k8s";
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

      tg = "TERRAGRUNT_PROVIDER_CACHE=1 TERRAGRUNT_PROVIDER_CACHE_DIR=~/.terraform.d/plugin-cache/ TERRAGRUNT_TFPATH=terraform terragrunt";
      tginfo = "TERRAGRUNT_PROVIDER_CACHE=1 TERRAGRUNT_PROVIDER_CACHE_DIR=~/.terraform.d/plugin-cache/ TERRAGRUNT_TFPATH=terraform terragrunt --terragrunt-debug";
      tgdebug = "TERRAGRUNT_PROVIDER_CACHE=1 TERRAGRUNT_PROVIDER_CACHE_DIR=~/.terraform.d/plugin-cache/ TERRAGRUNT_TFPATH=terraform TF_LOG=DEBUG terragrunt --terragrunt-debug";
      w = "wanda";

      k9s = "k9s --readonly";
      # kubens et kubectx;
      kns = "kubens";
      kcx = "kubectx";
      # quelques communs kube;
      kubectl = "kubecolor";
      k = "kubectl";
      kg = "kubectl get";
      kd = "kubectl describe";
      kgp = "kubectl get pods";
      kgns = "kubectl get namespaces";
      kgi = "kubectl get ingress";
      kgall = "kubectl get ingress,service,deployment,pod,statefulset";
      # switch between cluster;
      kuc = "kubectl config use-context";
      # set a namespace on the current context to avoid using --namespace all the time;
      kgc = "kubectl config get-contexts";
      kex = "kubectl exec -it";
      kl = "kubectl logs";
      # watch all pod ont he cluster;
      kwatch = "kubectl get pods -w --all-namespaces";

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
    shellInitLast = ''
      status is-interactive; and begin
         enable_transience

         # Set QEMU=1 if we're in QEMU
         if command -q systemd-detect-virt; and [ $(systemd-detect-virt) = "qemu" ]
           set -x QEMU 1
         end
       end
    '';
  };
}
