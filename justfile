# Home manager switch
home:
  home-manager switch --flake ".#gwen@thinkpad" --show-trace

# Nixos switch
rebuild:
  sudo nixos-rebuild switch --flake '.#thinkpad'
