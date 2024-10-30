import Network from "gi://AstalNetwork";
import { bind } from "astal";

export default function Wifi() {
  const { wifi } = Network.get_default();

  return (
    <box
      className="wifi"
    > 
      <icon
        icon={bind(wifi, "iconName")}
      />
      <label label={bind(wifi, "ssid").as(String)} />
    </box>
  );
}
