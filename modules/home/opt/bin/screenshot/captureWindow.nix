{config, ...}: let
  color = config.lib.stylix.colors;
in ''
  #!/usr/bin/env zsh
  sss --area "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)" --background "${color.base01}" -o raw | satty --early-exit -f - --copy-command wl-copy --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
''
