import * as NetworkUtils from "../../../shared/NetworkUtils";
import { bind } from "astal";
import Network from "gi://AstalNetwork";
import { Gtk } from "astal/gtk3";
import Pango from "gi://Pango";

export default function NetworkWidget() {
  const network = Network.get_default();
  const { wifi } = network;

  return (
    <box
      className={bind(network, "connectivity").as((conn) =>
        conn !== Network.Connectivity.NONE &&
        conn !== Network.Connectivity.UNKNOWN
          ? "network connected"
          : "network",
      )}
      vertical
      spacing={8}
    >
      <label label={"Network"} halign={Gtk.Align.START} />
      <box
        spacing={8}
        valign={Gtk.Align.END}
        halign={Gtk.Align.START}
      >
        {NetworkUtils.NetworkIcon()}
        {bind(network, "primary").as((primary) => {
          switch (primary) {
            case Network.Primary.WIFI:
              return (
                <label
                  label={bind(wifi, "ssid")}
                  ellipsize={Pango.EllipsizeMode.END}
                  max_width_chars={10}
                />
              );
            case Network.Primary.WIRED:
              return <label label={"Wired"} />;
            default:
              return <label label={"Unknown"} />;
          }
        })}
      </box>
    </box>
  );
}
