import Battery from "gi://AstalBattery";

import { bind } from "astal";
import Gtk from "gi://Gtk?version=3.0";

export default function BatteryLevel() {
  const bat = Battery.get_default();
  return (
    <box
      className={bind(bat, "charging").as((c) =>
        c ? "battery-label charging" : "battery-label",
      )}
      visible={bind(bat, "isPresent")}
    >
      <label
        valign={Gtk.Align.CENTER}
        label={bind(bat, "percentage").as(
          (p) => `${p > 0 ? Math.floor(p * 100) : 0}%`,
        )}
      />
      <circularprogress
        heightRequest={16}
        widthRequest={16}
        startAt={0.75}
        endAt={0.75}
        className={"progress"}
        rounded={true}
        value={bind(bat, "percentage").as((p) => (p > 0 ? p : 0))}
      />
    </box>
  );
}
