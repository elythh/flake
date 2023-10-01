{}:
{
  home.file.".xinitrc".text = ''
    #!/usr/bin/env zsh
    exec dbus-run-session awesome
  '';
}
