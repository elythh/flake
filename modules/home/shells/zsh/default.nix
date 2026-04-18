{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = builtins.elem "zsh" config.meadow.default.shell;
in
{
  imports = [ ./run-as-service.nix ];

  config = mkIf cfg {
    # sops.secrets."env.zsh" = {
    #   path = "${config.home.homeDirectory}/.config/zsh/env.zsh";
    # };
    programs.zsh = {
      enable = true;
      dotDir = "${config.home.homeDirectory}/.config/zsh";
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      envExtra = ''
        export PATH=~/.local/bin:~/.local/share/nvim/mason/bin:$PATH
      '';
      initExtra = ''
        if [[ -o login && -o interactive && -f ~/.ssh/id_default ]]; then
          ssh-add ~/.ssh/id_default >/dev/null 2>&1 < /dev/null
        fi
      '';
    };
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      settings = {
        style = "compact";
        show_tabs = false;
        show_help = false;
        enter_accept = true;
      };
    };
    home.file.kubie = {
      target = ".kube/kubie.yaml";
      text = ''
        prompt:
          disable: true
      '';
    };
  };
}
