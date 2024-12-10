import * as NetworkUtils from "../../../shared/NetworkUtils";
import { bind } from "astal";
import Network from "gi://AstalNetwork";
import { Gtk } from "astal/gtk3";

export default function Wifi() {
  const network = Network.get_default();

  return (
    <box
      className={bind(network, "connectivity").as((state) =>
        state !== Network.Connectivity.UNKNOWN &&
        state !== Network.Connectivity.NONE
          ? "wifi connected"
          : "wifi",
      )}
      vertical
      spacing={8}
      widthRequest={150}
    >
      <label label={"Network"} halign={Gtk.Align.START} />
      <box spacing={8} valign={Gtk.Align.END} halign={Gtk.Align.START}>
        <icon
          icon={bind(NetworkUtils.NetworkIcon())}
          css={"font-size: 13px;"}
          halign={Gtk.Align.START}
        />
        <label label={bind(NetworkUtils.NetworkName())} />
      </box>
    </box>
  );
}
