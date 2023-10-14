_:
''
  #!/usr/bin/env bash
  themes=$(find ~/.config/hypr/wallpapers/ -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
  
  # Use rofi to display the menu
  selected_theme=$(echo "$themes" | rofi -dmenu -p "Select a theme:")
  
  # Check if the user made a selection
  if [ -n "$selected_theme"  ]; then
      setTheme $selected_theme
  fi
''
