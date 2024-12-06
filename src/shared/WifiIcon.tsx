import Network from "gi://AstalNetwork";
import { bind } from "astal";
import { Gtk } from "astal/gtk3";

export default function WifiIcon() {
  const network = Network.get_default();
  const { wifi, wired } = network;

  return bind(network, "primary").as((n) => {
    if (n === Network.Primary.WIRED) {
      return (
        <icon
          tooltipText={"Wired"}
          valign={Gtk.Align.CENTER}
          halign={Gtk.Align.CENTER}
          icon={bind(wired, "iconName")}
          css={"font-size: 13px;"}
        />
      );
    } else if (n === Network.Primary.WIFI) {
      return (
        <icon
          tooltipText={bind(wifi, "ssid")}
          icon={bind(wifi, "iconName")}
          valign={Gtk.Align.CENTER}
          halign={Gtk.Align.CENTER}
          css={"font-size: 13px;"}
        />
      );
    } else {
      return (
        <icon
          tooltipText={"Unkown"}
          icon={"network-wireless-disabled-symbolic"}
          valign={Gtk.Align.CENTER}
          halign={Gtk.Align.CENTER}
          css={"font-size: 13px;"}
        />
      );
    }
  });
}
