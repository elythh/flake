{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) getExe mkIf mkEnableOption;
  city = "$(${getExe pkgs.jq} -r '.wttr | (.location)' ~/weather_config.json)";

  weather = pkgs.writeShellScriptBin "weather" ''
    #!/bin/bash
    curl -s "wttr.in/${city}?format=%l+%c|+%C+%t\n" 2>/dev/null
  '';

  playerctllock = pkgs.writeShellScriptBin "playerctllock" ''
     #!/usr/bin/env bash

     if [ $# -eq 0 ]; then
     	echo "Usage: $0 --title | --arturl | --artist | --length | --album | --source"
     	exit 1
     fi

     # Function to get metadata using playerctl
     getMetadata() {
     	key=$1
      playerctl metadata --format "{{ $key }}" 2>/dev/null
     }

     # Check for arguments

     # Function to determine the source and return an icon and text
     getSourceInfo() {
     	  trackid=$(getMetadata "mpris:trackid")

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

     getCover() {
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
      	title=$(getMetadata "xesam:title")

      	if [ ! -z "$title" ]; then
      		echo ''${title:0:28}
      	else
          :
      	fi
      	;;
     --arturl)
      	url=$(getMetadata "mpris:artUrl")

      	[[ -z "$url" ]] && exit 1
      	if [[ "$url" == file://* ]]; then
      		url=''${url#file://}
      	elif [[ "$url" == http://* ]] || [[ "$url" == https://* ]]; then
      		getCover
        fi
      	echo "$url"
      	;;
    --artist)
      artist=$(getMetadata "xesam:artist")

      if [ -n "$artist" ]; then
     	  echo ''${artist:0:30}
      else
        exit 1
      fi
     ;;
    --length)
    	duration=$(getMetadata "mpris:length")

    	[ -z "$duration" ] && exit 1

    	durationInSeconds=$((duration / 1000000))
    	minutes=$((durationInSeconds / 60))
    	seconds=$((durationInSeconds % 60))

      if [ ! -z "$duration" ]; then
        printf "%02d:%02d" "$minutes" "$seconds"
      else
        exit 1;
      fi
      ;;
    --status)
      status=$(playerctl status 2)

      if [[ $status == "Paused" ]]; then
        echo " "
      elif [[ $status == "Playing" ]]; then
        echo " "
      else
        exit 1
      fi
      ;;
    --album)
      album=$(getMetadata "xesam:album")
      length=''${#album}
      lim="20"

      if [[ -n $album ]]; then
        if [[ "$length" -gt "$lim" ]]; then
          echo ''${album:0:$lim}...
        else
          echo "$album"
        fi
      else
        exit 1
      fi
    ;;
    --source)
      getSourceInfo
      ;;
    *)
      echo "Invalid option: $1"
      echo "Usage: $0 --title | --arturl | --artist | --length | --album | --source"
      exit 1
      ;;
    esac
  '';

  cfg = config.opt.lock.hyprlock;
in
{
  options.opt.lock.hyprlock.enable = mkEnableOption "Hyprlock";

  config = mkIf cfg.enable {
    programs.hyprlock = with config.lib.stylix.colors; {
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
            text = "cmd[update:1000] ${getExe weather}";
            color = "rgba(255, 255, 255, 1)";
            font_size = 13;
            font_family = "JetBrainsMono NFM ExtraBold";
            position = "0, 465";
            halign = "center";
            valign = "center";
          }
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
            text = "cmd[update:1000] date +\"%d %b %A\"";
            color = "rgba(255, 255, 255, 1)";
            font_size = 14;
            font_family = "JetBrainsMono NFM ExtraBold";
            position = "0, -130";
            halign = "center";
            valign = "center";
          }
          # Status
          {
            monitor = "";
            text = "cmd[update:0] ${lib.getExe playerctllock} --status";
            color = "#${base0D}";
            font_size = 14;
            font_family = "JetBrainsMono Nerd Font Mono";
            position = "-740, -290";
            halign = "right";
            valign = "center";
          }
          # Artist
          {
            monitor = "";
            text = "cmd[update:0] ${lib.getExe playerctllock} --artist";
            color = "rgba(255, 255, 255, 0.8)";
            font_size = 10;
            font_family = "JetBrainsMono NFP ExtraBold";
            position = "880, -310";
            halign = "left";
            valign = "center";
          }
          # Title
          {
            monitor = "";
            text = "cmd[update:0] ${lib.getExe playerctllock} --title";
            color = "rgba(255, 255, 255, 0.8)";
            font_size = 12;
            font_family = "JetBrainsMono NFP ExtraBold";
            position = "880, -290";
            halign = "left";
            valign = "center";
          }
          # Song length
          {
            monitor = "";
            text = "cmd[update:0] ${lib.getExe playerctllock} --length";
            color = "rgba(255, 255, 255, 1)";
            font_size = 11;
            font_family = "JetBrainsMono Nerd Font Mono";
            position = "-740, -300";
            halign = "right";
            valign = "center";
          }
          # Album
          {
            monitor = "";
            text = "cmd[update:0] ${lib.getExe playerctllock} --album";
            color = "rgba(255, 255, 255, 1)";
            font_size = 10;
            font_family = "JetBrainsMono Nerd Font Mono";
            position = "880, -330";
            halign = "left";
            valign = "center";
          }
          {
            text = "cmd[update:0] ${lib.getExe playerctllock} --source";
            color = "rgba(255, 255, 255, 0.6)";
            font_size = "10";
            font_family = "JetBrainsMono Nerd Font Mono";
            position = "-740, -330";
            halign = "right";
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
            position = "-130, -300";
            halign = "center";
            valign = "center";
            #opacity=0.5
          }
        ];
      };
    };
  };
}
