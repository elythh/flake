{ nix-colors, config, ... }:
{
  home.file.".local/bin/lock" = with config.colorscheme.colors;{
    executable = true;
    text = ''
      #!/usr/bin/env sh
      playerctl pause
      # awesome-client "awesome.emit_signal('toggle::lock')"
      swaylock
    '';
  };
}

