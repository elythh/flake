##
## Aliases
##
alias s="kitty +kitten ssh"
alias grub-update='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias mirror-update='sudo reflector --verbose -c Indonesia -c Japan --sort rate --save /etc/pacman.d/mirrorlist'
alias mtar='tar -zcvf' # mtar <archive_compress>
alias utar='tar -zxvf' # utar <archive_decompress> <file_list>
alias z='zip -r' # z <archive_compress> <file_list>
alias uz='unzip' # uz <archive_decompress> -d <dir>
alias sr='source ~/.zshrc'
alias ..="cd .."
alias cfg='cd ~/.config/'
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e" 
alias mkdir="mkdir -p"
alias fm='ranger'
alias pacs="pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print \$2}\")' | xargs -ro sudo pacman -S"
alias pars="paru -Slq | fzf -m --preview 'cat <(paru -Si {1}) <(paru -Fl {1} | awk \"{print \$2}\")' | xargs -ro  paru -S"
alias pacr="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
alias p="pacman -Q | fzf"
alias wifi="nmtui-connect"
alias ls="exa --color=auto --icons"
alias l="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lt="ls --tree"
alias cat="bat --color always --plain"
alias grep='grep --color=auto'
alias v='nvim'
alias mv='mv -v'
alias cp='cp -vr'
alias rm='rm -vr'
alias commit="git add . && git commit -m"
alias push="git push"
alias g=git
alias ga='git add'
alias gaa='git add --all'
alias gam='git am'
alias gama='git am --abort'
alias gamc='git am --continue'
alias gams='git am --skip'
alias gamscp='git am --show-current-patch'
alias gap='git apply'
alias gapa='git add --patch'
alias gapt='git apply --3way'
alias gau='git add --update'
alias gav='git add --verbose'
alias gb='git branch'
alias gbD='git branch -D'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbda='git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch -d 2>/dev/null'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'
alias gc='git commit -v'
alias 'gc!'='git commit -v --amend'
alias gca='git commit -v -a'
alias 'gca!'='git commit -v -a --amend'
alias gcam='git commit -a -m'
alias 'gcan!'='git commit -v -a --no-edit --amend'
alias 'gcans!'='git commit -v -a -s --no-edit --amend'
alias gcas='git commit -a -s'
alias gcasm='git commit -a -s -m'
alias gcb='git checkout -b'
alias gcd='git checkout $(git_develop_branch)'
alias gcf='git config --list'
alias gclr='git clone --recurse-submodules'
alias gcl='git clone'
alias gcld='git clone --depth'
alias gclean='git clean -id'
alias gcm='git checkout $(git_main_branch)'
alias gcmsg='git commit -m'
alias 'gcn!'='git commit -v --no-edit --amend'
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit -S'
alias gcsm='git commit -s -m'
alias gcss='git commit -S -s'
alias gcssm='git commit -S -s -m'
alias gd='git diff'
alias gdca='git diff --cached'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gdcw='git diff --cached --word-diff'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdup='git diff @{upstream}'
alias gdw='git diff --word-diff'
alias gf='git fetch'
alias gfa='git fetch --all --prune --jobs=10'
alias gfg='git ls-files | grep'
alias gfo='git fetch origin'
alias gg='git gui citool'
alias gga='git gui citool --amend'
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpur=ggu
alias ggpush='git push origin "$(git_current_branch)"'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias ghh='git help'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'
alias gk='\gitk --all --branches &!'
alias gke='\gitk --all $(git log -g --pretty=%h) &!'
alias gl='git pull'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat -p'
alias glo='git log --oneline --decorate'
alias globurl='noglob urlglobber '
alias glod='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'
alias glods='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'' --date=short'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'' --all'
alias glols='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'' --stat'
alias glp=_git_log_prettily
alias glum='git pull upstream $(git_main_branch)'
alias gm='git merge'
alias gma='git merge --abort'
alias gmom='git merge origin/$(git_main_branch)'
alias gmtl='git mergetool --no-prompt'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/$(git_main_branch)'
alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease'
alias 'gpf!'='git push --force'
alias gpoat='git push origin --all && git push origin --tags'
alias gpr='git pull --rebase'
alias gpristine='git reset --hard && git clean -dffx'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gpu='git push upstream'
alias gpv='git push -v'
alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grwh='git rm --cached `git ls-files -i -c --exclude-from=.gitignore`'
alias grwhx='git ls-files -i -c --exclude-from=.gitignore | xargs git rm --cached'
alias grad='git rm -r --cached . && git add .'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase $(git_develop_branch)'
alias grbi='git rebase -i'
alias grbm='git rebase $(git_main_branch)'
alias grbo='git rebase --onto'
alias grbom='git rebase origin/$(git_main_branch)'
alias grbs='git rebase --skip'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias grev='git revert'
alias grh='git reset'
alias grhh='git reset --hard'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias groh='git reset origin/$(git_current_branch) --hard'
alias grrm='git remote remove'
alias grs='git restore'
alias grset='git remote set-url'
alias grss='git restore --source'
alias grst='git restore --staged'
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'
alias gsb='git status -sb'
alias gsd='git svn dcommit'
alias gsh='git show'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status -s'
alias gst='git status'
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstall='git stash --all'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gstu='gsta --include-untracked'
alias gsu='git submodule update'
alias gsw='git switch'
alias gswc='git switch -c'
alias gswd='git switch $(git_develop_branch)'
alias gswm='git switch $(git_main_branch)'
alias gtl='gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl'
alias gts='git tag -s'
alias gtv='git tag | sort -V'
alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupa='git pull --rebase --autostash'
alias gupav='git pull --rebase --autostash -v'
alias gupv='git pull --rebase -v'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

# vim:ft=zsh

# kubens et kubectx
alias kns='kubens'
alias kcx='kubectx'
# quelques alias communs kube
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kgp='kubectl get pods'
alias kgns='kubectl get namespaces'
alias kgi='kubectl get ingress'
alias kgall='kubectl get ingress,service,deployment,pod,statefulset'
# switch between cluster
alias kuc='kubectl config use-context'
# set a namespace on the current context to avoid using --namespace all the time
alias kgc='kubectl config get-contexts'
alias kex='kubectl exec -it'
alias kl='kubectl logs'
# watch all pod ont he cluster
alias kwatch='kubectl get pods -w --all-namespaces'

# Convenient way of decoding a kubernetes secret
kdecode() {
  kubectl get secret -o json $@ | jq '.data | map_values(@base64d)'
}

## Check logs from all namespaces for an app
unalias wk 2>/dev/null
wk() {
  watch kubectl get pods -l "app=$1" --all-namespaces
}

# Force a rolling update of a deployment
alias kru='kubectl rollout restart deployment'

# Force a rolling update of a statefulset
alias krus='kubectl rollout restart statefulset'

# Force a rolling update of a daemonset
alias krud='kubectl rollout restart daemonset'

# Portforward to one pod with label app=$1
unalias kpf 2>/dev/null
kpf() {
  local APP
  APP=$1
  shift
  local PORT
  PORT=$1
  shift
  local POD_NAME
  POD_NAME=$(kubectl "$@" get pod -l app="${APP}" -o jsonpath='{$.items[0].metadata.name}')
  kubectl "$@" port-forward "${POD_NAME}" "${PORT}:${PORT}"
}
