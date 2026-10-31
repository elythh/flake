{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3; # older home-manager: pinentryPackage = pkgs.pinentry-gnome3;
  };
}
