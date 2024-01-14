_:
''
  #!/usr/bin/env sh
  THEME=$1
  sed -i "/theme = */c\theme = \"$THEME\";" /etc/nixos/home/gwen/home.nix
  cd /etc/nixos && home-manager switch --flake ".#$USER@thinkpad"
  echo $THEME > /tmp/themeName
  systemctl --user restart waybar.service swaybg.service
''
