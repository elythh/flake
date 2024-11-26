import WifiIcon from "../../../shared/WifiIcon";
import { Gtk } from "astal/gtk3";

export default function Wifi() {
  return (
    <button className="wifi" heightRequest={30} widthRequest={30} valign={Gtk.Align.START}>
      {WifiIcon()}
    </button>
  );
}
