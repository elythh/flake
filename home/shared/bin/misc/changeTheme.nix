_:
''
  #!/usr/bin/env sh
  THEME=$1
  sed -i "5s/.*/  colors = import ..\/shared\/cols\/$THEME.nix { };/g" /etc/nixos/home/gwen/home.nix
  cd /etc/nixos && home-manager switch --flake ".#$USER@thinkpad"
  echo $THEME > /tmp/themeName
  eww reload
  kill -USR1 $(pidof wezterm-gui)
  awesome-client 'awesome.emit_signal("colors::refresh")'
''
