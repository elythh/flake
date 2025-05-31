{ pkgs, ... }:
pkgs.writeShellScriptBin "screenshot" ''
  SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
  mkdir -p "$SCREENSHOT_DIR"

  IMAGE_NAME=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
  SAVED_IMAGE="$SCREENSHOT_DIR/$IMAGE_NAME"
  TMP_SCREENSHOT="/tmp/$IMAGE_NAME"

  case $1 in
    "f")
      ${pkgs.wayshot}/bin/wayshot -f $TMP_SCREENSHOT
    ;;
    "s")
      ${pkgs.wayshot}/bin/wayshot -s "$(${pkgs.slurp}/bin/slurp)" -f $TMP_SCREENSHOT
    ;;
    "a")
      ${pkgs.grimblast}/bin/grimblast save area $TMP_SCREENSHOT
    ;;
    *)
      exit
    ;;
  esac

  ${pkgs.wl-clipboard}/bin/wl-copy < $TMP_SCREENSHOT

  if [ ! -f "$TMP_SCREENSHOT" ]; then
    exit
  fi

  ACTION=$(${pkgs.libnotify}/bin/notify-send "Screenshot" "Screenshot copied to clipboard." -i "multimedia-photo-viewer-symbolic" -A "save=Save")

  case "$ACTION" in
    "save")
      SWAPPY_DIR="$HOME/.config/swappy/"
      mkdir -p $SWAPPY_DIR
      echo -e "[Default]\nsave_dir=$SCREENSHOT_DIR\nsave_filename_format=$IMAGE_NAME" > $SWAPPY_DIR/config

      ${pkgs.swappy}/bin/swappy -f $TMP_SCREENSHOT

      if [ -f "$SAVED_IMAGE" ]; then
        ${pkgs.libnotify}/bin/notify-send "Image Saved" "Image saved successfully." -i "multimedia-photo-viewer-symbolic"
        rm "$TMP_SCREENSHOT"
      fi
    ;;
    *)
      exit
    ;;
  esac
''
