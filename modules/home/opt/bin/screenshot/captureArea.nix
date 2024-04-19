_: ''
  #!/usr/bin/env zsh
  sss --area "$(slurp)" -o raw | satty --early-exit -f - --copy-command wl-copy --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
''
