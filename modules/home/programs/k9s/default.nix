{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.meadow.programs.k9s;
in
{
  options.meadow.programs.k9s.enable = mkEnableOption "k9s";

  config = mkIf cfg.enable {
    programs.k9s = {
      enable = true;

      settings.skin = "k9s";
    };
    sops.secrets.kubernetes = {
      path = "${config.home.homeDirectory}/.kube/config";
      mode = "0700";
    };
    xdg.configFile."k9s/plugins/debug.yml".text = ''
      plugins:
        #--- Create debug container for selected pod in current namespace
        # See https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/#ephemeral-container
        debug:
          shortCut: Shift-D
          description: Add debug container
          dangerous: true
          scopes:
            - containers
          command: bash
          background: false
          confirm: true
          args:
            - -c
            - "kubectl --kubeconfig=$KUBECONFIG debug -it --context $CONTEXT -n=$NAMESPACE $POD --target=$NAME --image=nicolaka/netshoot:v0.13 --share-processes -- bash"
    '';
  };
}
