{ ... }: {
  security = {
    rtkit.enable = true;
    polkit.enablePkexecWrapper = true;
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
    };
    polkit.enable = true;
  };
}
