import { App, Astal, Gtk } from "astal/gtk3";

import LauncherButton from "./components/LauncherButton";
import SysTray from "./components/SysTray";
import Workspaces from "./components/Workspaces";
import Clock from "./components/Clock";
import BatteryLevel from "./components/Battery";
import Indicators from "./components/Indicators";

const BOXCSS = "margin: 0.2rem 0.8rem";

function BarStart() {
  return (
    <box halign={Gtk.Align.START} css={BOXCSS} spacing={8}>
      <LauncherButton />
      <SysTray />
    </box>
  );
}

function BarCenter() {
  return (
    <box css={BOXCSS} spacing={8}>
      <Workspaces />
    </box>
  );
}

function BarEnd() {
  return (
    <box halign={Gtk.Align.END} css={BOXCSS} spacing={8}>
      <Clock />
      <BatteryLevel />
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
