import * as NetworkUtils from "../../../shared/NetworkUtils";
import { bind } from "astal";
import Network from "gi://AstalNetwork";
import { Gtk } from "astal/gtk3";
import Pango from "gi://Pango";
import Toggle from "./shared/Toggle";

export default function NetworkInfo() {
  const network = Network.get_default();
  const { wifi } = network;

  return (
    <Toggle
      title="Network"
      clicked={() => {
        const primary = network.get_primary();

        switch (primary) {
          case Network.Primary.WIRED:
            break;
          default:
            wifi.set_enabled(!wifi.get_enabled());
            break;
        }
      }}
      info={
        <box spacing={8} valign={Gtk.Align.END} halign={Gtk.Align.START}>
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
      }
      className={bind(network, "connectivity").as((conn) =>
        conn !== Network.Connectivity.NONE &&
        conn !== Network.Connectivity.UNKNOWN
          ? "info active"
          : "info",
      )}
    />
  );
}
