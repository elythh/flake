{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    zplug = {
      enable = true;
      plugins = [
        { name = "hlissner/zsh-autopair"; }
        { name = "zdharma-continuum/fast-syntax-highlighting"; }
        { name = "MichaelAquilina/zsh-you-should-use"; }
        { name = "Aloxaf/fzf-tab"; }
        { name = "zsh-users/zsh-history-substring-search"; }
      ];
    };
    shellAliases = {
      nf = "neofetch";
      suda = "sudo -E -s";
      nix-pkgs = "nix --extra-experimental-features 'nix-command flakes' search nixpkgs";
      s = "kitty +kitten ssh";
      mirror-update = "sudo reflector - -verbose - c Indonesia - c Japan - -sort rate - -save /etc/pacman.d/mirrorlist ";
      mtar = "tar - zcvf"; # mtar <archive_compress>;
      utar = "tar - zxvf"; # utar <archive_decompress> <file_list>;
      z = "zip -r"; # z <archive_compress> <file_list>
      sr = "source ~/.zshrc";
      cfg = "cd ~/.config/";
      psg = "ps aux | grep - v grep | grep - i - e VSZ - e ";
      mkdir = "mkdir -p ";
      pacs = " pacman - Slq | fzf - m - -preview 'cat < (pacman - Si { 1}) <(pacman -Fl {1} | awk \"{print \$2}\")' | xargs -ro sudo pacman -S";
      pars = "paru -Slq | fzf -m --preview 'cat <(paru -Si {1}) <(paru -Fl {1} | awk \"{print \$2}\")' | xargs -ro  paru -S";
      pacr = "pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns";
      p = "pacman -Q | fzf";
      wifi = "nmtui-connect";
      ls = "exa --color=auto --icons";
      l = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      lt = "ls --tree";
      cat = "bat --color always --plain";
      grep = "grep --color=auto";
      v = "nvim";
      mv = "mv -v";
      cp = "cp -vr";
      rm = "rm -vr";
      commit = "git add . && git commit -m";
      push = "git push";
      ga = "git add";
      gaa = "git add --all";
      gam = "git am";
      gama = "git am --abort";
      gamc = "git am --continue";
      gams = "git am --skip";
      gamscp = "git am --show-current-patch";
      gap = "git apply";
      gapa = "git add --patch";
      gapt = "git apply --3way";
      gau = "git add --update";
      gav = "git add  --verbose";
      gb = "git branch";
      gbD = "git branch -D";
      gba = "git branch -a";
      gbd = "git branch -d";
      gbl = "git blame -b -w";
      gbnm = "git branch --no-merged";
      gbr = "git branch --remote";
      gbs = "git bisect";
      gbsb = "git bisect bad";
      gbsg = "git bisect good";
      gbsr = "git bisect reset";
      gbss = "git bisect start";
      gc = "git commit -v";
      gca = "git commit -v -a";
      "gca!" = "git commit -v -a --amend";
      gcam = "git commit -a -m";
      "gcan!" = "git commit -v -a --no-edit --amend";
      "gcans!" = "git commit -v -a -s --no-edit --amend";
      gcas = "git commit -a -s";
      gcasm = "git commit -a -s -m";
      gcb = "git checkout -b";
      gcd = "git checkout $(git_develop_branch)";
      gcf = "git config --list";
      gclr = "git clone --recurse-submodules";
      gcl = "git clone";
      gcld = "git clone --depth";
      gclean = "git clean -id";
      gcm = "git checkout $(git_main_branch)";
      gcmsg = "git commit -m";
      gco = "git checkout";
      gcor = "git checkout --recurse-submodules";
      gcount = "git shortlog -sn";
      gcp = "git cherry-pick";
      gcpa = "git cherry-pick --abort";
      gcpc = "git cherry-pick --continue";
      gcs = "git commit -S";
      gcsm = "git commit -s -m";
      gcss = "git commit -S -s";
      gcssm = "git commit -S -s -m";
      gd = "git diff";
      gdca = "git diff --cached";
      gdct = "git describe --tags $(git rev-list --tags --max-count=1)";
      gdcw = "git diff --cached --word-diff";
      gds = "git diff --staged";
      gdt = "git diff-tree --no-commit-id --name-only -r";
      gdup = "git diff @{upstream}";
      gdw = "git diff --word-diff";
      gf = "git fetch";
      gfa = "git fetch --all --prune --jobs=10";
      gfg = "git ls-files | grep";
      gfo = "git fetch origin";
      gg = "git gui citool";
      gga = "git gui citool --amend";
      ggpull = "git pull origin '$(git_current_branch)'";
      ggpush = "git push origin '$(git_current_branch) '";
      ggsup = "git branch --set-upstream-to=origin/$(git_current_branch)";
      ghh = "git help";
      gignore = "git update-index --assume-unchanged";
      git-svn-dcommit-push = "git svn dcommit && git push github $(git_main_branch):svntrunk";
      gk = "\gitk --all --branches &!";
      gke = "\gitk --all $(git log -g --pretty=%h) &!";
      gl = "git pull";
      glg = "git log --stat";
      glgg = "git log --graph";
      glgga = "git log --graph --decorate --all";
      glgm = "git log --graph --max-count=10";
      glgp = "git log --stat -p";
      glo = "git log --oneline --decorate";
      globurl = "noglob urlglobber ";
      glod = "git log - -graph - -pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'";
      grh = "git reset";
      grhh = "git reset - -hard";
      grm = "git rm";
      grmc = "git rm --cached";
      grmv = "git remote rename";
      groh = "git reset origin/$(git_current_branch) --hard";
      grrm = "git remote remove";
      grs = "git restore";
      grset = "git remote set-url";
      grss = "git restore --source";
      grst = "git restore --staged";
      gru = "git reset --";
      grup = "git remote update";
      grv = "git remote -v";
      gsb = "git status -sb";
      gsd = "git svn dcommit";
      gsh = "git show";
      gsi = "git submodule init";
      gsps = "git show --pretty=short --show-signature";
      gsr = "git svn rebase";
      gss = "git status -s";
      gst = "git status";
      gsta = "git stash push";
      gstaa = "git stash apply";
      gstall = "git stash --all";
      gstc = "git stash clear";
      gstd = "git stash drop";
      gstl = "git stash list";
      gstp = "git stash pop";
      gsts = "git stash show --text";
      gstu = "gsta --include-untracked";
      gsu = "git submodule update";
      gsw = "git switch";
      gswc = "git switch -c";
      gswd = "git switch $(git_develop_branch)";
      gswm = "git switch $(git_main_branch)";
      gtv = " git tag | sort - V ";
      gunignore = " git update-index - -no-assume-unchanged ";
      gunwip = " git log - n 1 | grep - q - c '\ - \-wip\ - \-' && git reset HEAD~1";
      gup = " git pull - -rebase ";
      gupa = " git pull - -rebase - -autostash ";
      gupav = " git pull - -rebase - -autostash - v ";
      gupv = " git pull - -rebase - v ";
      gwch = " git whatchanged - p - -abbrev-commit - -pretty=medium";
      gwip = "git add -A";
      kns = " kubens ";
      kcx = " kubectx ";
      k = " kubectl ";
      kg = " kubectl get ";
      kd = " kubectl describe ";
      kgp = " kubectl get pods ";
      kgns = " kubectl get namespaces ";
      kgi = " kubectl get ingress ";
      kgall = "kubectl get ingress,service,deployment,pod,statefulset";
      kuc = "kubectl config use-context";
      kgc = "kubectl config get-contexts";
      kex = "kubectl exec -it";
      kl = "kubectl logs";
      kwatch = "kubectl get pods -w --all-namespaces";
      kru = "kubectl rollout restart deployment";
      krus = "kubectl rollout restart statefulset";
      krud = "kubectl rollout restart daemonset";
    };
    history = {
      expireDuplicatesFirst = true;
      save = 512;
    };
    initExtra = ''
      bindkey  "^[[H"   beginning-of-line
      bindkey  "^[[4~"   end-of-line
      bindkey  "^[[3~"  delete-char
      export PATH=${config.home.homeDirectory}/.local/bin:${config.home.homeDirectory}/.local/share/nvim/mason/bin:$PATH
      export LD_LIBRARY_PATH=${config.home.homeDirectory}/.config/awesome:${pkgs.lua54Packages.lua}/lib/:${pkgs.pam}/lib
      export NIX_CONFIG="experimental-features = nix-command flakes"
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$cmd_duration\n[ ](fg:blue)  ";
      git_branch.format = "via [$symbol$branch(:$remote_branch)]($style) ";
      command_timeout = 1000;
    };
  };
}




































