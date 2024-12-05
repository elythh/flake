import Battery from "gi://AstalBattery";

import { bind } from "astal";

export default function BatteryLevel() {
  const bat = Battery.get_default();
  return (
    <box
      tooltipText={bind(bat, "percentage").as(
        (p) => `Battery: ${p > 0 ? Math.floor(p * 100) : 0}%`,
      )}
      className={bind(bat, "charging").as((c) =>
        c ? "battery-label charging" : "battery-label",
      )}
      spacing={6}
      visible={bind(bat, "isPresent")}
    >
      <icon
        icon={`battery-flash-symbolic`}
        className={"battery-flash"}
        visible={bind(bat, "charging")}
      />
      <box>
        <box className={"battery-bulb"} widthRequest={2} />
        <levelbar
          value={bind(bat, "percentage").as((p) => (p > 0 ? p : 0))}
          widthRequest={30}
          inverted={true}
        />
      </box>
    </box>
  );
}
