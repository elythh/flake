import { Gtk } from "astal/gtk3";
import { Variable, execAsync } from "astal";

// Thank you procps
export default function Uptime() {
  const uptime_pretty = Variable<string>("").poll(1000, () =>
    execAsync("uptime -p"),
  );

  return (
    <label
      heightRequest={24}
      halign={Gtk.Align.END}
      label={uptime_pretty()}
      onDestroy={() => uptime_pretty.drop()}
    />
  );
}
