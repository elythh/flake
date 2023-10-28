_:
''
  #!/usr/bin/env bash


  toggle_menu() {
    if [[ $(eww windows | grep -w '*calendar') ]]; then
      eww close calendar
      eww open menu
    else
      eww open --toggle menu
    fi
  }

  toggle_calendar() {
    if [[ $(eww windows | grep -w '*menu') ]]; then
      eww close menu
      eww open calendar
    else
      eww open --toggle calendar
    fi
  }

  case $1 in
  --menu)
    toggle_menu
    ;;
  --launcher)
    eww open --toggle launcher
    python $XDG_CONFIG_HOME/eww/scripts/apps.py --query
    ;;
  --bar)
    main
    ;;
  --calendar)
    toggle_calendar
    ;;
  esac
''
