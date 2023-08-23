{ pkgs, ... }:

{
  services.gpg-agent = {
    enable = true;
  };
}
