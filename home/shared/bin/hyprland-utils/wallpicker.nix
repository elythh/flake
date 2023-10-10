_:
''
  #!/usr/bin/bash

  # Define your wallpapers folder
  walldir="$(echo "$HOME/Pictures/wal/")"

  # cd to the walldir
  cd $(echo $walldir)

  # Get selected file from wofi
  selection=$(ls -1F | wofi --show=dmenu) 

  # fullpath of the desired or selected file
  file="${walldir}${selection}"

  # change wallpaper with swww
  swww img $file

  # notify to your system
  notify-send -i $file  -t 1200 "Wall changed to ${selection}"
''
