import { USER } from "../../../shared/constants";
import { Gtk } from "astal/gtk3";
import { Variable, execAsync } from "astal";

export default function Uptime() {
  const uptime_pretty = Variable<string>("").poll(1000, () =>
    execAsync("uptime -p"),
  );

  return (
    <centerbox
      className={"uptime"}
      startWidget={<label halign={Gtk.Align.START} label={USER} />}
      end_widget={
        <label
          halign={Gtk.Align.END}
          label={uptime_pretty()}
          onDestroy={() => uptime_pretty.drop()}
        />
      }
    />
  );
}
