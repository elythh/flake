{ pkgs, ... }:
{
  environment = {
    shells = with pkgs; [
      nushell
      zsh
    ];
    variables.FLAKE = "/etc/nixos";
  };
}
