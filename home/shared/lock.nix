{ colors }:
{
  home.file.".local/bin/lock" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      playerctl pause
      # awesome-client "awesome.emit_signal('toggle::lock')"
      swaylock
    '';
  };
}

