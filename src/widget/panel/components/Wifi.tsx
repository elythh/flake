import WifiIcon from "../../../shared/WifiIcon";
import AstalNetwork from "gi://AstalNetwork";

export default function Wifi() {
  const network = AstalNetwork.get_default();
  const { wifi } = network;

  const toggleWifi = () => {
    if (wifi == null) return;

    wifi.set_enabled(!wifi.get_enabled());
  };

  return (
    <button
      className="wifi"
      heightRequest={30}
      widthRequest={30}
      onClicked={toggleWifi}
    >
      {WifiIcon()}
    </button>
  );
}
