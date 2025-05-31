{
  config,
  lib,
  pkgs,
  ...
}: {
  programs = {
    git = {
      enable = true;
      userEmail = "gwen@omg.lol";
      userName = "elyth";

      ignores = [
        "*.log"
        ".envrc"
        "shell.nix"
      ];

      extraConfig = {
        url = {
          "ssh://git@gitlab.dnm.radiofrance.fr:" = {
            insteadOf = "https://gitlab.dnm.radiofrance.fr/";
          };
        };
        # Sign all commits using ssh key
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_default.pub";
        core = {
          editor = "nvim";
          excludesfile = "~/.config/git/ignore";
          pager = "${lib.getExe pkgs.diff-so-fancy}";
        };
        pager = {
          diff = "${lib.getExe pkgs.diff-so-fancy}";
          log = "delta";
          reflog = "delta";
          show = "delta";
        };

        credential = {
          helper = "store";
        };

        color = {
          ui = true;
          pager = true;
          diff = "auto";
          branch = {
            current = "green bold";
            local = "yellow dim";
            remove = "blue";
          };

          showBranch = "auto";
          interactive = "auto";
          grep = "auto";
          status = {
            added = "green";
            changed = "yellow";
            untracked = "red dim";
            branch = "cyan";
            header = "dim white";
            nobranch = "white";
          };
        };
      };

      aliases = {
        st = "status ";
        ci = "commit ";
        br = "branch ";
        co = "checkout ";
        df = "diff ";
        dc = "diff - -cached ";
        lg = "log - p ";
        pr = "pull - -rebase ";
        p = "push ";
        ppr = "push - -set-upstream origin ";
        lol = "log - -graph - -decorate - -pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        latest = "for-each-ref --sort=-taggerdate --format='%(refname:short)' --count=1";
        undo = "git reset --soft HEAD^";
        brd = "branch -D";
      };
    };

    zsh.initContent =
      # bash
      ''
        export GITHUB_TOKEN="$(cat ${config.sops.secrets."github/access-token".path})"
        export ANTHROPIC_API_KEY="$(cat ${config.sops.secrets."ANTHROPIC_API_KEY".path})"
        export LINODE_TOKEN="$(cat ${config.sops.secrets."ANTHROPIC_API_KEY".path})"
      '';
    fish.interactiveShellInit =
      # bash
      ''
        export GITHUB_TOKEN="$(cat ${config.sops.secrets."github/access-token".path})"
        export GITLAB_TOKEN="$(cat ${config.sops.secrets."gitlab/access-token".path})"
        export GITLAB_URL="$(cat ${config.sops.secrets."gitlab/url".path})"
        export ANTHROPIC_API_KEY="$(cat ${config.sops.secrets."ANTHROPIC_API_KEY".path})"
        export LINODE_TOKEN="$(cat ${config.sops.secrets."LINODE_TOKEN".path})"
      '';
  };

  sops.secrets = {
    "github/access-token" = {
      path = "${config.home.homeDirectory}/.config/gh/access-token";
    };
    "gitlab/access-token" = {
      path = "${config.home.homeDirectory}/.config/gitlab/access-token";
    };
    "gitlab/url" = {
      path = "${config.home.homeDirectory}/.config/gitlab/url";
    };
    "GITPRIVATETOKEN" = {
      path = "${config.home.homeDirectory}/.gitcreds";
    };
    "ANTHROPIC_API_KEY" = {
      path = "${config.home.homeDirectory}/.config/ANTHROPIC_API_KEY";
    };
    "LINODE_TOKEN" = {
      path = "${config.home.homeDirectory}/.config/LINODE_TOKEN";
    };
  };
}
