import AstalNotifd from "gi://AstalNotifd";
import { Gtk, Astal } from "astal/gtk3";
import { timeout, idle } from "astal";

const notifd = AstalNotifd.get_default();
const TRANSITION_DURATION = 300;

function NotifIcon(notif: AstalNotifd.Notification) {
  const icon = (
    <icon
      icon={
        Astal.Icon.lookup_icon(notif.app_icon)
          ? notif.app_icon
          : "dialog-information-symbolic"
      }
      css={"font-size: 38px;"}
      valign={Gtk.Align.CENTER}
      halign={Gtk.Align.CENTER}
    />
  );

  return <centerbox className={"notif-icon"} centerWidget={icon} />;
}

function Notif(notif: AstalNotifd.Notification) {
  const Title = () => (
    <label
      className={"title"}
      justify={Gtk.Justification.LEFT}
      halign={Gtk.Align.START}
      truncate={true}
      label={notif.summary}
      useMarkup={true}
    />
  );

  const Body = () => (
    <label
      className={"body"}
      justify={Gtk.Justification.LEFT}
      halign={Gtk.Align.START}
      maxWidthChars={24}
      wrap={true}
      label={notif.body.trim()}
      useMarkup={true}
    />
  );

  const Content = (
    <box
      className={"content"}
      spacing={8}
      vertical={true}
      vexpand={true}
      hexpand={true}
    >
      <Title />
      <Body />
    </box>
  );

  const Actions =
    notif.get_actions().length > 0 ? (
      <box className={"actions"} spacing={8}>
        {notif.get_actions().map((a) => (
          <button
            className={"action-button"}
            hexpand={true}
            onClicked={() => {
              notif.invoke(a.id);
              notif.dismiss();
            }}
            child={<label label={a.label} />}
          ></button>
        ))}
      </box>
    ) : null;

  const NotifInner = (
    <eventbox onClick={() => notif.dismiss()}>
      <box className={`notification ${notif.urgency}`}>
        {NotifIcon(notif)}
        <box vertical={true} className={"left"}>
          {Content}
          {Actions}
        </box>
      </box>
    </eventbox>
  );

  const InnerRevealer = (
    <revealer
      transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
      transitionDuration={TRANSITION_DURATION}
    >
      {NotifInner}
    </revealer>
  );

  const OuterRevealer = (
    <revealer
      name={notif.id.toString()}
      transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
      transitionDuration={TRANSITION_DURATION}
    >
      {InnerRevealer}
    </revealer>
  );

  idle(() => {
    (OuterRevealer as Gtk.Revealer).revealChild = true;
    timeout(TRANSITION_DURATION, () => {
      (InnerRevealer as Gtk.Revealer).revealChild = true;
    });
  });

  return OuterRevealer;
}

export default function NotificationPopups(monitor = Gdk.Monitor) {
  const notifs: Gtk.Widget[] = [];

  function removeNotifPopup(widget: ReturnType<typeof Notif>) {
    if (widget.visible === false) return;

    const outerRevealer = widget as Gtk.Revealer;
    const innerRevealer = outerRevealer.get_child() as Gtk.Revealer;

    innerRevealer.revealChild = false;

    timeout(TRANSITION_DURATION, () => {
      outerRevealer.revealChild = false;
      timeout(TRANSITION_DURATION, () => {
        widget.destroy();
      });
    });
  }

  const NotifList = (
    <box vertical={true} className={"notifications"}>
      {notifs}
    </box>
  );

  notifd.connect("notified", (_, id) => {
    const notif = notifd.get_notification(id);
    if (notif) {
      const lst = NotifList as Astal.Box;
      const old = lst.get_children();
      const n = Notif(notif);
      lst.set_children([...old, n]);

      const expire =
        notif.get_expire_timeout() > 0
          ? notif.get_expire_timeout() * 1000
          : 3000;

      // Like 5 million errors
      timeout(expire, () => removeNotifPopup(n));
    }
  });

  notifd.connect("resolved", (_, id) => {
    const lst = NotifList as Astal.Box;
    const widget = lst.get_children().find((n) => n.name === id.toString());
    if (widget) removeNotifPopup(widget);
  });

  return (
    <window
      gdkmonitor={monitor}
      // name={`notifications${monitor}`}
      className={"notification-popups"}
      anchor={Astal.WindowAnchor.TOP}
      layer={Astal.Layer.OVERLAY}
    >
      {NotifList}
    </window>
  );
}
