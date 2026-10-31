{ pkgs, ... }:
{
  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      webkitgtk_4_1
      gtk3
      glib
      cairo
      pango
      gdk-pixbuf
      libsoup_3
      openssl
      dbus
      librsvg
      libayatana-appindicator
      zlib
    ];
    zsh.enable = true;
    fish.enable = true;
    dconf.enable = true;
    wshowkeys.enable = true;
    gpu-screen-recorder = {
      enable = true;
      ui.enable = true;
    };
  };
}
