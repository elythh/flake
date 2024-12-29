import { Gtk } from "astal/gtk3";
import { bind } from "astal";
import Notifd from "gi://AstalNotifd";
import Toggle from "./shared/Toggle";

export default function DoNotDisturb() {
  const notifd = Notifd.get_default();

  return (
    <Toggle
      title="Do Not Disturb"
      clicked={() => {
        notifd.set_dont_disturb(!notifd.get_dont_disturb());
      }}
      info={
        <box spacing={8} valign={Gtk.Align.END} halign={Gtk.Align.START}>
          <icon icon={"dnd-symbolic"} />
          <label
            label={bind(notifd, "dontDisturb").as((dnd) =>
              dnd ? "On" : "Off",
            )}
          />
        </box>
      }
      className={bind(notifd, "dontDisturb").as((dnd) =>
        dnd ? "info active" : "info",
      )}
    />
  );
}
