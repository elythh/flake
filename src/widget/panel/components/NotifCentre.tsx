import {
  NotifWidget,
  NOTIF_TRANSITION_DURATION,
} from "../../notifs/NotifWidget";
import AstalNotifd from "gi://AstalNotifd";
import { Gtk } from "astal/gtk3";
import { bind } from "astal";

const notifd = AstalNotifd.get_default();

export default function NotifCentre() {
  const NotifWidgets = bind(notifd, "notifications").as((n) =>
    n.map(NotifWidget),
  );

  const NotifList = (
    <box vertical={true} className={"notifications"}>
      {NotifWidgets}
    </box>
  );

  return (
    <box className={"notif-centre"}>
      <scrollable
        widthRequest={300}
        heightRequest={380}
        hscroll={Gtk.PolicyType.NEVER}
        child={NotifList}
      ></scrollable>
    </box>
  );
}
