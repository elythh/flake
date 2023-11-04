{ ... }:
{
  home.file.".xinitrc".text = ''
    #!/usr/bin/env bsah
    exec dbus-run-session awesome
  '';
}
