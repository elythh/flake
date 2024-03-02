_default:
  just --list

# Nix flake check
check:
  nix flake check

# Home manager switch, default is thinkpad
home profile="thinkpad":
  home-manager switch --flake ".#gwen@{{ profile }}" --show-trace

# Nixos switch, default is thinkpad
rebuild profile="thinkpad":
  sudo nixos-rebuild switch --flake '.#{{ profile }}'
