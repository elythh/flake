import { App, Astal, Gtk } from "astal/gtk3";

import LauncherButton from "./components/LauncherButton";
import Workspaces from "./components/Workspaces";
import Clients from "./components/Clients";
import SysTray from "./components/SysTray";
import Clock from "./components/Clock";
import BatteryLevel from "./components/Battery";
import Indicators from "./components/Indicators";
import Separator from "../../astalify/Separator";

function BarStart() {
  return (
    <box
      halign={Gtk.Align.START}
      spacing={8}
      css={"margin-left: 0.8em;"}
      hexpand={true}
    >
      <LauncherButton />
      <Separator />
      <Workspaces />
    </box>
  );
}

function BarCenter() {
  return (
    <box
      spacing={8}
      css={"margin: 0 0.8em;"}
      hexpand={true}
    >
      {Clients()}
    </box>
  );
}

function BarEnd() {
  return (
    <box halign={Gtk.Align.END} spacing={8} css={"margin-right: 0.8em"}>
      <Clock />
      <BatteryLevel />
      <Separator />
      <SysTray />
      <Indicators />
    </box>
  );
}

export default function Bar(monitor = 0) {
  const anchor =
    Astal.WindowAnchor.RIGHT |
    Astal.WindowAnchor.BOTTOM |
    Astal.WindowAnchor.LEFT;
  return (
    <window
      name={`bar-${monitor}`}
      application={App}
      className="bar"
      monitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={anchor}
      heightRequest={12}
    >
      <centerbox
        className="cbox"
        startWidget={BarStart()}
        centerWidget={BarCenter()}
        endWidget={BarEnd()}
      ></centerbox>
    </window>
  );
}
