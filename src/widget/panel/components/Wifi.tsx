import WifiIcon from "../../../shared/WifiIcon";
import { Gtk } from "astal/gtk3";

export default function Wifi() {
  return (
    <button className="wifi" heightRequest={38} widthRequest={38} valign={Gtk.Align.START}>
      {WifiIcon()}
    </button>
  );
}
