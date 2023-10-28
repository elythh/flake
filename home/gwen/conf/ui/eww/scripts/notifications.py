#!/usr/bin/env python
# juminai @ github

import gi
import datetime
import os
import typing
import sys
import json
import subprocess
import dbus
import dbus.service

gi.require_version("GdkPixbuf", "2.0")
gi.require_version("Gtk", "3.0")

from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib, Gtk, GdkPixbuf
from html.parser import HTMLParser

log_file = os.path.expandvars("$XDG_CACHE_HOME/eww/notifications.json")
cache_dir = os.path.expandvars("$XDG_CACHE_HOME/eww/notifications_img")
os.makedirs(cache_dir, exist_ok=True)


class NotificationDaemon(dbus.service.Object):
    def __init__(self):
        bus_name = dbus.service.BusName("org.freedesktop.Notifications", dbus.SessionBus())
        dbus.service.Object.__init__(self, bus_name, "/org/freedesktop/Notifications")

        self.dnd = False
        self.active_popups = {}

    @dbus.service.method("org.freedesktop.Notifications", in_signature="susssasa{sv}i", out_signature="u")
    def Notify(self, app_name, replaces_id, app_icon, summary,  body, actions, hints, expire_timeout,):

        if int(replaces_id) != 0:
            id = int(replaces_id)
        else:
            log_data = self.read_log_file()
            notifications = log_data.get("notifications", [])

            if notifications:
                id = notifications[0]["id"] + 1
            else:
                id = 1

        actions = list(actions)
        action_pairs = []

        for i in range(0, len(actions), 2):
            action_pair = [str(actions[i]), str(actions[i + 1])]
            action_pairs.append(action_pair)

        details = {
            "id": id,
            "app": app_name or None,
            "summary": self.clean_text(summary) or None,
            "body": self.clean_text(body) or None,
            "time": datetime.datetime.now().strftime("%H:%M"),
            "actions": action_pairs,
        }

        if app_icon.strip():
            if os.path.isfile(app_icon) or app_icon.startswith("file://"):
                details["image"] = app_icon
            else:
                details["image"] = self.get_gtk_icon(app_icon)
        else:
            details["image"] = None

        if "image-data" in hints:
            details["image"] = f"{cache_dir}/{details['id']}.png"
            self.save_img_byte(hints["image-data"], details["image"])

        self.save_notification(details)
        if not self.dnd:
            self.save_popup(details)
        return id

    @dbus.service.method("org.freedesktop.Notifications", in_signature="", out_signature="ssss")
    def GetServerInformation(self):
        return ("eww notification daemon", "klyn", "1.0", "1.2")

    @dbus.service.method("org.freedesktop.Notifications", in_signature="", out_signature="as")
    def GetCapabilities(self):
        return ("actions", "body", "icon-static", "persistence")

    @dbus.service.signal("org.freedesktop.Notifications", signature="us")
    def ActionInvoked(self, id, action):
        return (id, action)

    @dbus.service.method("org.freedesktop.Notifications", in_signature="us", out_signature="")
    def InvokeAction(self, id, action):
        self.ActionInvoked(id, action)

    @dbus.service.signal("org.freedesktop.Notifications", signature="uu")
    def NotificationClosed(self, id, reason):
        return (id, reason)

    @dbus.service.method("org.freedesktop.Notifications", in_signature="u", out_signature="")
    def CloseNotification(self, id):
        current = self.read_log_file()
        current["notifications"] = [n for n in current["notifications"] if n["id"] != id]
        current["count"] = len(current["notifications"])

        self.write_log_file(current)
        self.NotificationClosed(id, 2)
        self.DismissPopup(id)

    @dbus.service.method("org.freedesktop.Notifications", in_signature="", out_signature="")
    def ToggleDND(self):
        self.dnd = not self.dnd

        current = self.read_log_file()
        current["dnd"] = self.dnd
        self.write_log_file(current)

    @dbus.service.method("org.freedesktop.Notifications", in_signature="", out_signature="")
    def ClearAll(self):
        for notify in self.read_log_file()["notifications"]:
            self.NotificationClosed(notify["id"], 2)
        empty = {"count": 0, "dnd": self.dnd, "notifications": [], "popups": []}

        self.write_log_file(empty)

    @dbus.service.method("org.freedesktop.Notifications", in_signature="u", out_signature="")
    def DismissPopup(self, id):
        current = self.read_log_file()
        current["popups"] = [n for n in current["popups"] if n["id"] != id]

        self.write_log_file(current)
        self.active_popups.pop(id, None)

    def clean_text(self, text):
        class HTMLTagStripper(HTMLParser):
            def __init__(self):
                super().__init__()
                self.reset()
                self.strict = False
                self.convert_charrefs = True
                self.text = []

            def handle_data(self, data):
                self.text.append(data)

            def get_text(self):
                return "".join(self.text)

        stripper = HTMLTagStripper()
        stripper.feed(text)
        text = stripper.get_text()

        return text.strip()

    def get_gtk_icon(self, icon_name):
        theme = Gtk.IconTheme.get_default()
        icon_info = theme.lookup_icon(icon_name, 128, 0)

        if icon_info is not None:
            return icon_info.get_filename()

    def save_img_byte(self, px_args: typing.Iterable, save_path: str):
        GdkPixbuf.Pixbuf.new_from_bytes(
            width=px_args[0],
            height=px_args[1],
            has_alpha=px_args[3],
            data=GLib.Bytes(px_args[6]),
            colorspace=GdkPixbuf.Colorspace.RGB,
            rowstride=px_args[2],
            bits_per_sample=px_args[4],
        ).savev(save_path, "png")

    def write_log_file(self, data):
        output_json = json.dumps(data, indent=2)
        with open(log_file, "w") as log:
            log.write(output_json)
        subprocess.run(["eww", "update", f"notifications={output_json}"])

    def read_log_file(self):
        empty = {"count": 0, "dnd": self.dnd, "notifications": [], "popups": []}
        try:
            with open(log_file, "r") as log:
                return json.load(log)
        except FileNotFoundError:
            with open(log_file, "w") as log:
                json.dump(empty, log)
            return empty

    def save_notification(self, notification):
        current = self.read_log_file()
        current["notifications"].insert(0, notification)
        current["count"] = len(current["notifications"])

        self.write_log_file(current)

    def save_popup(self, notification):
        current = self.read_log_file()
        if len(current["popups"]) >= 3:
            oldest_popup = current["popups"].pop()
            self.DismissPopup(oldest_popup["id"])

        current["popups"].insert(0, notification)
        self.write_log_file(current)

        popup_id = notification["id"]
        self.active_popups[popup_id] = GLib.timeout_add_seconds(6, self.DismissPopup, popup_id)


def main():
    DBusGMainLoop(set_as_default=True)
    loop = GLib.MainLoop()
    NotificationDaemon()
    try:
        loop.run()
    except KeyboardInterrupt:
        exit(0)


if __name__ == "__main__":
    main()
