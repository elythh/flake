#!/usr/bin/env python
# juminai @ github

import dbus
import json
import gi
import subprocess

from gi.repository import GLib
from dbus.mainloop.glib import DBusGMainLoop

def get_player_property(player_interface, prop):
    try:
        return player_interface.Get("org.mpris.MediaPlayer2.Player", prop)
    except dbus.exceptions.DBusException:
        return None

def format_time(seconds):
    if seconds < 3600:
        minutes = seconds // 60
        remaining_seconds = seconds % 60
        return f"{minutes:02d}:{remaining_seconds:02d}"
    else:
        hours = seconds // 3600
        minutes = (seconds % 3600) // 60
        remaining_seconds = seconds % 60
        return f"{hours:02d}:{minutes:02d}:{remaining_seconds:02d}"
    
def clean_name(name):
    # Remove "instance" prefix
    name = name.split(".instance")[0]
    # Remove "org.mpris.MediaPlayer2." prefix
    name = name.replace("org.mpris.MediaPlayer2.", "")
    return name
    
def get_all_mpris_data():
    session_bus = dbus.SessionBus()
    bus_names = session_bus.list_names()

    players = []

    for name in bus_names:
        if "org.mpris.MediaPlayer2." in name:
            try:
                player = session_bus.get_object(name, "/org/mpris/MediaPlayer2")
                player_interface = dbus.Interface(player, "org.freedesktop.DBus.Properties")
                metadata = get_player_property(player_interface, "Metadata")
                
                playback_status = get_player_property(player_interface, "PlaybackStatus")
                
                if playback_status != "Stopped":
                    shuffle = bool(get_player_property(player_interface, "Shuffle"))
                    loop_status = get_player_property(player_interface, "LoopStatus")
                    can_go_next = bool(get_player_property(player_interface, "CanGoNext"))
                    can_go_previous = bool(get_player_property(player_interface, "CanGoPrevious"))
                    can_play = bool(get_player_property(player_interface, "CanPlay"))
                    can_pause = bool(get_player_property(player_interface, "CanPause"))
                    volume = get_player_property(player_interface, "Volume")
                    volume = round(volume, 2) * 100 if volume is not None else None
                    length = metadata.get("mpris:length") 
                    length = length // 1000000 if length is not None else None

                    data = {
                        "name": clean_name(name),
                        "title": metadata.get("xesam:title", "Unknown"),
                        "artist": metadata.get("xesam:artist", ["Unknown"])[0],
                        "album": metadata.get("xesam:album", "Unknown"),
                        "artUrl": metadata.get("mpris:artUrl", None),
                        "status": playback_status,
                        "length": length,
                        "lengthStr": format_time(length) if length is not None else None,
                        "shuffle": shuffle,
                        "loop": loop_status,
                        "volume": volume,
                        "canGoNext": can_go_next,
                        "canGoPrevious": can_go_previous,
                        "canPlay": can_play,
                        "canPause": can_pause,
                    }

                    players.append(data)
                        
            except dbus.exceptions.DBusException:
                pass

    return players

def on_properties_changed(interface, changed_properties, invalidated_properties):
    subprocess.run(["eww", "update", "mpris={}".format(json.dumps(get_all_mpris_data()))])

if __name__ == "__main__":
    DBusGMainLoop(set_as_default=True)
    mainloop = GLib.MainLoop()
    
    session_bus = dbus.SessionBus()
    session_bus.add_signal_receiver(
        on_properties_changed,
        dbus_interface="org.freedesktop.DBus",
        signal_name="NameOwnerChanged"
    )
    bus_names = session_bus.list_names()

    for name in bus_names:
        if "org.mpris.MediaPlayer2." in name:
            try:
                player = session_bus.get_object(name, "/org/mpris/MediaPlayer2")
                player_interface = dbus.Interface(player, "org.freedesktop.DBus.Properties")
                player.connect_to_signal("PropertiesChanged", on_properties_changed)
                
                subprocess.run(["eww", "update", "mpris={}".format(json.dumps(get_all_mpris_data()))])

            except dbus.exceptions.DBusException:
                pass
    
    try:
        mainloop.run()
    except KeyboardInterrupt:
        session_bus.close()