#!/usr/bin/env python

import dbus
import json
import sys
import time

from mpris import get_player_property, format_time, clean_name
    
def get_positions(session_bus, bus_names):
    positions = {}
    status = {}

    for name in bus_names:
        if "org.mpris.MediaPlayer2." in name:
            try:
                player = session_bus.get_object(name, "/org/mpris/MediaPlayer2")
                player_interface = dbus.Interface(player, "org.freedesktop.DBus.Properties")
                playback_status = get_player_property(player_interface, "PlaybackStatus")

                position = get_player_property(player_interface, "Position")
                position = position // 1000000 if position is not None else None
                
                positions[clean_name(name)] = {
                    "position": position, 
                    "positionStr": format_time(position) if position is not None else None
                }
                
                status[clean_name(name)] = {"status": str(playback_status)}

            except dbus.exceptions.DBusException:
                pass
    
    return positions, status

if __name__ == "__main__":
    session_bus = dbus.SessionBus()
    
    try:
        while True:
            bus_names = session_bus.list_names()
            positions, playback_status = get_positions(session_bus, bus_names)
            
            playback_status_str = json.dumps(playback_status)
            all_stopped = all(status_data["status"] != "Playing" for status_data in playback_status.values())
               
            if not all_stopped:
                sys.stdout.write(json.dumps(positions) + "\n")
                sys.stdout.flush()
            time.sleep(1)
    except KeyboardInterrupt:
        sys.exit(0)
