{ config
, pkgs
, lib
, ...
}:
let
  playerctllock = pkgs.writeShellScriptBin "playerctllock" ''
     #!/usr/bin/env bash

     if [ $# -eq 0 ]; then
     	echo "Usage: $0 --title | --arturl | --artist | --length | --album | --source"
     	exit 1
     fi

     # Function to get metadata using playerctl
     get_metadata() {
     	key=$1
      playerctl metadata --format "{{ $key }}" 2>/dev/null
     }

     # Check for arguments

     # Function to determine the source and return an icon and text
     get_source_info() {
     	  urackid=$(get_metadata "mpris:trackid")

     	case "$trackid" in
     		*Feishin* ) echo -e "Feishin " ;;
        *spotify* ) echo -e "Spotify " ;;
        *Firefox* ) echo -e "Firefox " ;;
     		*chromium* ) echo -e "Chrome " ;;
     	  *) 
        : 
        ;; # Do nothing
     	esac
     }

     get_cover() {
            local tempfile="/tmp/tmp.xG2g4TRv4i"
            local path="/tmp/cover.png"

            if [[ "$url" != $(< "$tempfile") ]]; then
                     curl "$url" -o "$path" 
                     mogrify -format png "$path"
                     echo "$url" > "$tempfile"
            fi
            url="$path"
     }

     # Parse the argument
     case "$1" in
     --title)
      	title=$(get_metadata "xesam:title")

      	if [ ! -z "$title" ]; then
      		echo ''${title:0:28}
      	else
          :
      	fi
      	;;
     --arturl)
      	url=$(get_metadata "mpris:artUrl")

      	[[ -z "$url" ]] && : # Do nothing
      	if [[ "$url" == file://* ]]; then
      		url=''${url#file://}
      	elif [[ "$url" == http://192.168.1.20:8096/* ]]; then
      		get_cover
        fi
      	echo "$url"
      	;;
    --artist)
      artist=$(get_metadata "xesam:artist")

      if [ ! -z "$artist" ]; then
     	  echo ''${artist:0:30}
      else
        : # Do nothing
      fi
     ;;
    --length)
      duration=$(get_metadata "mpris:length")
      duration_in_seconds=$((duration / 1000000))
      remaining_time=$((duration_in_seconds - current_position))
      minutes=$((remaining_time / 60))
      seconds=$((remaining_time % 60))

      if [ ! -z "$duration" ];
      then
      printf "%02d:%02d" "$minutes" "$seconds"
      else
      : # Do nothing
      fi
      ;;
    --status)
      status=$(playerctl status 2 > /dev/null)

      if [[ $status == "Paused" ]];
      then
        echo ""
      elif [[ $status == "Playing" ]]; then
        echo ""
      else
        : # Do nothing
      fi
      ;;
    --album)
      album=$(playerctl metadata --format "{{ xesam:album }}" 2 > /dev/null)
      length=''${#album}
      lim="20"

      if [[ -n $album ]]; then
        if [[ "$length" -gt "$lim" ]]; then
          echo ''${album:0:$lim}...
        else
          echo "$album"
        fi
      else
        :
      fi
    ;;
    --source)
      get_source_info
      ;;
    *)
      echo "Invalid option: $1"
      echo "Usage: $0 --title | --arturl | --artist | --length | --album | --source"
      exit 1
      ;;
    esac
  '';
in
{
  config = lib.mkIf (config.default.lock == "hyprlock" && config.default.de == "hyprland") {
    programs.hyprlock = with config.lib.stylix.colors;
      {
        enable = true;

        settings = {
          general = {
            disable_loading_bar = true;
            grace = 3;
            hide_cursor = true;
            no_fade_in = false;
          };

          background = [
            {
              path = "${config.wallpaper}";
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          input-field = [
            {
              size = "200, 50";
              position = "0, -470";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              inner_color = "rgba(0, 0, 0, 1)";
              font_color = "rgba(200, 200, 200, 1)";
              outline_thickness = 5;
              placeholder_text = "Password...";
              shadow_passes = 2;
            }
          ];
          # Time
          label = [
            {
              text = "cmd[update:1000] date +\"%H\"";
              color = "#${base05}";
              font_size = 150;
              font_family = "AlfaSlabOne";
              position = "0, -250";
              halign = "center";
              valign = "top";
            }
            {
              text = "cmd[update:1000] date +\"%M\"";
              color = "#${base05}";
              font_size = 150;
              font_family = "AlfaSlabOne";
              position = "0, -420";
              halign = "center";
              valign = "top";
            }
            # Date
            {
              text = "cmd[update:1000] date +\"%d %b %A\"\"%H \"";
              color = "#${base05}";
              font_size = 25;
              font_family = "ZedMono NF";
              position = "0, -130";
              halign = "center";
              valign = "center";
            }
            {
              monitor = "";
              text = "cmd[update:0] ${lib.getExe playerctllock} --status";
              color = "#${base0D}";
              font_size = 14;
              font_family = "ZedMono NF";
              position = "-740, -290";
              halign = "right";
              valign = "center";
            }
            {
              monitor = "";
              text = "cmd[update:0] ${lib.getExe playerctllock} --artist";
              color = "#${base0F}";
              font_size = 14;
              font_family = "ZedMono NF";
              position = "880, -310";
              halign = "left";
              valign = "center";
            }
            {
              monitor = "";
              text = "cmd[update:0] ${lib.getExe playerctllock} --title";
              color = "#${base0F}";
              font_size = 14;
              font_family = "ZedMono NF";
              position = "880, -290";
              halign = "left";
              valign = "center";
            }
            {
              monitor = "";
              text = "cmd[update:0] ${lib.getExe playerctllock} --length";
              color = "#${base0F}";
              font_size = 14;
              font_family = "ZedMono NF";
              position = "-740, -310";
              halign = "right";
              valign = "center";
            }
            {
              monitor = "";
              text = "cmd[update:0] ${lib.getExe playerctllock} --album";
              color = "#${base0F}";
              font_size = 14;
              font_family = "ZedMono NF";
              position = "880, -330";
              halign = "left";
              valign = "center";
            }
          ];

          # Image
          image = [
            {
              monitor = "";
              path = "";
              size = "60";
              rounding = "5";
              border_size = "0";
              rotate = "0";
              reload_time = "2";
              reload_cmd = "${lib.getExe playerctllock} --arturl";
              position = "-130, -309";
              halign = "center";
              valign = "center";
              #opacity=0.5
            }
          ];
        };
      };
  };
}
