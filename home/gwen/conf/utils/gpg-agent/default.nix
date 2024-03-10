{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };
}
