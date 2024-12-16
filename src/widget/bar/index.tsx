import { App, Astal, Gtk, Gdk } from "astal/gtk3";

import LauncherButton from "./components/LauncherButton";
import Workspaces from "./components/Workspaces";
import Clients from "./components/Clients";
import SysTray from "./components/SysTray";
import Clock from "./components/Clock";
import BatteryLevel from "./components/Battery";
import Indicators from "./components/Indicators";

function BarStart() {
  return (
    <box halign={Gtk.Align.START} spacing={8} hexpand={true}>
      <LauncherButton />
      <Workspaces />
    </box>
  );
}

function BarCenter() {
  return (
    <box spacing={8} hexpand={true}>
      {Clients()}
    </box>
  );
}

function BarEnd() {
  return (
    <box halign={Gtk.Align.END} spacing={8}>
      <box spacing={12}>
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
    Astal.WindowAnchor.BOTTOM |
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
        centerWidget={BarCenter()}
        endWidget={BarEnd()}
      ></centerbox>
    </window>
  );
}
