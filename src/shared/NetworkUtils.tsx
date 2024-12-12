import Network from "gi://AstalNetwork";
import { bind } from "astal";

const network = Network.get_default();
const { wifi, wired } = network;

// Variable.derive still causes the code to freak out since wifi could possibly be null
// Accessing the wifi & network fields from the binding doesn't make icons, etc. reactive
// This way sucks but at least it works
export function NetworkIcon() {
  return bind(network, "primary").as((primary) => {
    switch (primary) {
      case Network.Primary.WIFI:
        return <icon icon={bind(wifi, "iconName")} />;
      case Network.Primary.WIRED:
        return <icon icon={bind(wired, "iconName")} />;
      default:
        return <icon icon={"network-wireless-disabled-symbolic"} />;
    }
  });
}
