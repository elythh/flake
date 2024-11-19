import Network from "gi://AstalNetwork";
import { bind } from "astal";

export default function WifiIcon() {
  const network = Network.get_default();
  const { wifi, wired } = network;

  return bind(network, "primary").as((n) => {
    if (n === Network.Primary.WIRED) {
      return <icon tooltipText={"Wired"} icon={bind(wired, "iconName")} />;
    } else if (n === Network.Primary.WIFI) {
      return (
        <icon tooltipText={bind(wifi, "ssid")} icon={bind(wifi, "iconName")} />
      );
    } else {
      return <icon tooltipText={"Unkown"} icon={"dialog-question-symbolic"} />;
    }
  });
}
