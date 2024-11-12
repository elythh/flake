import { Gtk, Astal, App } from "astal/gtk3";
import { PopupWindow } from "../PopupWindow";
import Audio from "./components/Audio";
import Wifi from "./components/Wifi";
import NotifCentre from "./components/NotifCentre";

export default function Panel() {
  const anchor = Astal.WindowAnchor.BOTTOM |  Astal.WindowAnchor.RIGHT;

  return (
    <PopupWindow
      name="panel"
      application={App}
      transition={Gtk.RevealerTransitionType.SLIDE_RIGHT}
      anchor={anchor}
      keymode={Astal.Keymode.ON_DEMAND}
    >
      <box className="panel-box" vertical={true} spacing={8}>
        <NotifCentre />
        <Audio />
        <Wifi />
      </box>
    </PopupWindow>
  );
}
