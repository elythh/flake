{ config, ... }:
let color = config.colorscheme.palette;
in ''
  #!/usr/bin/env zsh
  sss --area "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)" --background "${color.background}" -o raw | satty --early-exit -f - --copy-command wl-copy --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
''
