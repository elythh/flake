# Home manager switch
home:
  home-manager switch --flake ".#gwen@thinkpad" --show-trace

work:
  home-manager switch --flake ".#gwen@hp" --show-trace
# Nixos switch
rebuild:
  sudo nixos-rebuild switch --flake '.#thinkpad'

rebuild-work:
  sudo nixos-rebuild switch --flake '.#hp'
