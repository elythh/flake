{
  programs.git = {
    enable = true;
    userEmail = "gwen@omg.lol";
    userName = "elyth";

    signing = {
      signByDefault = true;
      key = "34DA47B5677E214D";
    };

    ignores = [
      "*.log"
      ".envrc"
      "shell.nix"
    ];

    extraConfig = {
      core = {
        editor = "nvim";
        excludesfile = "~/.config/git/ignore";
        pager = "delta";
      };
      pager = {
        diff = "delta";
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
      st = " status ";
      ci = "
        commit ";
      br = "
        branch ";
      co = "
        checkout ";
      df = "
        diff ";
      dc = "
        diff - -cached ";
      lg = "
        log - p ";
      pr = "
        pull - -rebase ";
      p = "
        push ";
      ppr = "
        push - -set-upstream origin ";
      lol = "
        log - -graph - -decorate - -pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      latest = "for-each-ref --sort=-taggerdate --format='%(refname:short)' --count=1";
      undo = "git reset --soft HEAD^";
      brd = "branch -D";
    };
  };

}
