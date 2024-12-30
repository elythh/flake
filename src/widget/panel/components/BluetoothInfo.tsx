import Bluetooth from "gi://AstalBluetooth";
import { bind, Variable } from "astal";
import { Gtk } from "astal/gtk3";
import Pango from "gi://Pango";
import Toggle from "./shared/Toggle";

export default function BluetoothInfo() {
  const bluetooth = Bluetooth.get_default();

  const bluetoothLabel = Variable.derive(
    [
      bind(bluetooth, "is_powered"),
      bind(bluetooth, "devices"),
      bind(bluetooth, "adapter"),
      bind(bluetooth, "is_connected"),
    ],
    (powered, devices, adapter, _) => {
      if (powered) {
        for (const device of devices) {
          if (device.connected) {
            return (
              <label
                label={bind(device, "alias")}
                ellipsize={Pango.EllipsizeMode.END}
                max_width_chars={12}
              />
            );
          }
        }
        return <label label={"On"} />;
      }
      if (adapter) return <label label={"Off"} />;

      return <label label={"Unavailable"} />;
    },
  );

  return (
    <Toggle
      title="Bluetooth"
      clicked={() => {
        const adapter = bluetooth.get_adapter();
        adapter?.set_powered(!adapter.get_powered());
      }}
      info={
        <box spacing={8} valign={Gtk.Align.END} halign={Gtk.Align.START}>
          <icon
            icon={bind(bluetooth, "is_powered").as((powered) =>
              powered
                ? "bluetooth-active-symbolic"
                : "bluetooth-disabled-symbolic",
            )}
            css={"font-size: 13px"}
          />
          {bluetoothLabel()}
        </box>
      }
      className={bind(bluetooth, "is_powered").as((powered) =>
        powered ? "info active" : "info",
      )}
      cursor={bind(bluetooth, "adapter").as((adapter) =>
        adapter ? "pointer" : "not-allowed",
      )}
      onDestroy={() => bluetoothLabel.drop()}
    />
  );
}
