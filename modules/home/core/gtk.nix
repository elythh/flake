{pkgs, ...}: {
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    iconTheme.name = "Reversal-dark";
    theme.name = "phocus";
    font = {
      name = "ZedMono NF";
      size = 11;
    };
  };
}
