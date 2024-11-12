import AstalNotifd from "gi://AstalNotifd";
import { Gtk, Astal } from "astal/gtk3";
import { timeout } from "astal";
import { NotifWidget, NOTIF_TRANSITION_DURATION } from "../NotifWidget";

const notifd = AstalNotifd.get_default();

export default function NotificationPopups(monitor = 0) {
  const notifMap: Map<number, Gtk.Widget> = new Map();

  const NotifList = <box vertical={true} className={"notifications"} />;

  function removeNotifPopup(id : number) {

    const widget = notifMap.get(id);

    if (!widget) return;

    const outerRevealer = widget as Gtk.Revealer;
    const innerRevealer = outerRevealer.get_child() as Gtk.Revealer;

    innerRevealer.revealChild = false;

    timeout(NOTIF_TRANSITION_DURATION, () => {
      outerRevealer.revealChild = false;
      timeout(NOTIF_TRANSITION_DURATION, () => {
        widget.destroy();
      });
    });

    notifMap.delete(id);
  }

  notifd.connect("notified", (_, id) => {
    const notif = notifd.get_notification(id);

    if (notif) {
      const lst = NotifList as Astal.Box;

      notifMap.get(id)?.destroy();
      notifMap.set(id, NotifWidget(notif));

      lst.set_children([...notifMap.values()].reverse());

      const expire =
        notif.get_expire_timeout() > 0
          ? notif.get_expire_timeout() * 1000
          : 3000;

      timeout(expire, () => removeNotifPopup(id));
    }
  });

  notifd.connect("resolved", (_, id) => {
    removeNotifPopup(id);
  });

  const anchor = Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT;

  return (
    <window
      monitor={monitor}
      name={`notifications${monitor}`}
      className={"notification-popups"}
      anchor={anchor}
      layer={Astal.Layer.OVERLAY}
    >
      {NotifList}
    </window>
  );
}
