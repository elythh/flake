_: ''
  #!/usr/bin/env sh
  THEME=$1
  sed -i "s/theme = .*/ theme  = \"$THEME\";"/1 /etc/nixos/home/gwen/home.nix
  cd /etc/nixos && home-manager switch --flake ".#$USER@thinkpad"
  echo $THEME > /tmp/themeName
''
