_:
''
  #!/usr/bin/env bash

  # requieres dunst hyprpicker imagemagick wl-clipboard

  TEMP_DIR=/tmp/colorpicker

  [ ! -d $TEMP_DIR ] && mkdir -p $TEMP_DIR

  abort() {
    notify-send -a "Color Picker info" -i dialog-error "Color Picker" "aborted"
    exit 1
  }

  pick() {
    HEX_COLOR=$(hyprpicker)

    [[ -z $HEX_COLOR ]] && abort

    HEX="${HEX_COLOR#\#}"
    FNAME="$TEMP_DIR/$HEX.png"

    convert -size 100x100 xc:"$HEX_COLOR" "$FNAME"

    COLOR_CODE="$HEX_COLOR"

    echo "$COLOR_CODE" | wl-copy -n

    notify-send -u low -a "Color Picker" -i "$FNAME" $COLOR_CODE "Copied to clipboard"
  }

  pick
''
