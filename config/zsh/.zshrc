

## ░▀▀█░█▀▀░█░█░█▀▄░█▀▀
## ░▄▀░░▀▀█░█▀█░█▀▄░█░░
## ░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀
##
## rxyhn's Z-Shell configuration
## https://github.com/rxyhn

while read file
do 
  source "$ZDOTDIR/$file.zsh"
done <<-EOF
theme
aliases
utility
options
plugins
keybinds
EOF

if [[ $TERM != "dumb" ]]; then
  eval "$(/home/gwen/.nix-profile/bin/starship init zsh)"
fi

# vim:ft=zsh:nowrap

