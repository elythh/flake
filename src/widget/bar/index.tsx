import { App, Astal, Gtk, Gdk } from "astal/gtk3";

import LauncherButton from "./components/LauncherButton";
import Workspaces from "./components/Workspaces";
import SysTray from "./components/SysTray";
import Clock from "./components/Clock";
import BatteryLevel from "./components/Battery";
import Indicators from "./components/Indicators";

function BarStart() {
  return (
    <box halign={Gtk.Align.START} spacing={5} hexpand={true}>
      <LauncherButton />
      <Workspaces />
    </box>
  );
}

function BarEnd() {
  return (
    <box halign={Gtk.Align.END} spacing={5}>
      <box spacing={10}>
        <Clock />
        <BatteryLevel />
        <SysTray />
      </box>
      <Indicators />
    </box>
  );
}

export default function Bar(monitor: Gdk.Monitor, index: number) {
  const anchor =
    Astal.WindowAnchor.RIGHT |
    Astal.WindowAnchor.TOP |
    Astal.WindowAnchor.LEFT;
  return (
    <window
      name={`bar-${index}`}
      application={App}
      className="bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={anchor}
      heightRequest={12}
    >
      <centerbox
        className="cbox"
        spacing={8}
        startWidget={BarStart()}
        endWidget={BarEnd()}
      ></centerbox>
    </window>
  );
}
