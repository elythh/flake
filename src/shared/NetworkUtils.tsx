import Network from "gi://AstalNetwork";
import { bind, Variable } from "astal";

const network = Network.get_default();

export function NetworkIcon() {
  return Variable.derive(
    [bind(network, "primary"), bind(network, "wired"), bind(network, "wifi")],
    (primary, wired, wifi) => {
      switch (primary) {
        case Network.Primary.WIRED:
          return wired.iconName;
        case Network.Primary.WIFI:
          return wifi.iconName;
        case Network.Primary.UNKNOWN:
          return "network-wireless-disabled-symbolic";
        default:
          return "network-wireless-disabled-symbolic";
      }
    },
  );
}

export function NetworkName() {
  return Variable.derive(
    [bind(network, "primary"), bind(network, "wifi")],
    (primary, wifi) => {
      switch (primary) {
        case Network.Primary.WIRED:
          return "Wired";
        case Network.Primary.WIFI:
          return wifi.ssid;
        case Network.Primary.UNKNOWN:
          return "Unknown";
        default:
          return "Unknown";
      }
    },
  );
}
