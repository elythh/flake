_:
''
  #!/usr/bin/env bash

  [[ -z $(pgrep checkvolume) ]] && checkvolume &

  # requieres pamixer

  case $1 in
  --up)
    pamixer -u >/dev/null
    pamixer -i 2 >/dev/null
    ;;
  --down)
    pamixer -u >/dev/null
    pamixer -d 2 >/dev/null
    ;;
  --toggle)
    pamixer -t >/dev/null
    ;;
    esac
''
