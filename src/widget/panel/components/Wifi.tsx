import Network from "gi://AstalNetwork";
import { bind } from "astal";
import WifiIcon from "../../../shared/WifiIcon";

export default function Wifi() {
  const network = Network.get_default();
  const { wifi } = network;

  return (
    <box className="wifi">
      {WifiIcon()}
      {bind(network, "primary").as((n) => {
        if (n === Network.Primary.WIRED) {
          return <label label={"Wired"} />;
        } else if (n === Network.Primary.WIFI) {
          return <label label={bind(wifi, "ssid")} />;
        } else {
          // TODO: Find a better icon for this (unknown network)
          return <label label={"Unknown"} />;
        }
      })}
    </box>
  );
}
