{config, ...}: let
  color = config.lib.stylix.colors;
in ''
  wl-paste | sss_code --window-controls --window-title "code moche" -n -e yaml --background '#${color.base06}' -f png -o raw - | satty --early-exit -f - --copy-command wl-copy --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
''
