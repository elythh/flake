{
  security = {
    rtkit.enable = true;
    pam.services = {
      greetd = {
        gnupg.enable = true;
        enableGnomeKeyring = true;
      };
      login = {
        enableGnomeKeyring = true;
        gnupg = {
          enable = true;
          noAutostart = true;
          storeOnly = true;
        };
      };
      swaylock.text = "auth include login";
    };
    polkit.enable = true;
  };
}
