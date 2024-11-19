import AstalNotifd from "gi://AstalNotifd";
import { Gtk, Astal } from "astal/gtk3";
import { timeout, idle } from "astal";
import GLib from "gi://GLib";

const NOTIF_TRANSITION_DURATION = 300;

function NotifIcon(notif: AstalNotifd.Notification) {
  const icon = (
    <icon
      icon={
        Astal.Icon.lookup_icon(notif.app_icon)
          ? notif.app_icon
          : "dialog-information-symbolic"
      }
      css={"font-size: 38px;"} valign={Gtk.Align.CENTER}
      halign={Gtk.Align.CENTER}
    />
  );

  return <centerbox className={"notif-icon"} centerWidget={icon} />;
}

const time = (time: number, format = "%H:%M") =>
  GLib.DateTime.new_from_unix_local(time).format(format)!;

export function removeNotif(id: number, notifMap: Map<number, Gtk.Widget>) {
  const widget = notifMap.get(id);

  if (widget == null) return;

  const revealerWrapper = widget as Gtk.Revealer;

  revealerWrapper.revealChild = false;

  timeout(NOTIF_TRANSITION_DURATION, () => {
    widget.destroy();
  });

  notifMap.delete(id);
}

export function NotifWidget(notif: AstalNotifd.Notification) {
  const Title = (
    <label
      className={"title"}
      justify={Gtk.Justification.LEFT}
      halign={Gtk.Align.START}
      truncate={true}
      maxWidthChars={100}
      label={notif.summary}
      useMarkup={true}
    />
  );

  const Time = (
    <label
      className={"time"}
      justify={Gtk.Justification.RIGHT}
      halign={Gtk.Align.END}
      label={time(notif.time)}
    />
  );

  const Body = (
    <label
      className={"body"}
      justify={Gtk.Justification.LEFT}
      halign={Gtk.Align.START}
      wrap={true}
      label={notif.body.trim()}
      useMarkup={true}
    />
  );

  const Header = (
    <centerbox
      className={"header"}
      startWidget={Title}
      endWidget={Time}
    ></centerbox>
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
            }}
            child={<label label={a.label} />}
          ></button>
        ))}
      </box>
    ) : null;

  const NotifInner = (
    <eventbox onClick={() => notif.dismiss()}>
      <box
        className={`notification ${notif.urgency}`}
        widthRequest={330}
        vertical={true}
      >
        {Header}
        <box>
          {NotifIcon(notif)}
          <box className="left" vertical={true} valign={Gtk.Align.CENTER}>
            {Body}
            {Actions}
          </box>
        </box>
      </box>
    </eventbox>
  );

  const RevealerWrapper = (
    <revealer
      transitionType={Gtk.RevealerTransitionType.SLIDE_UP}
      revealChild={false}
      transitionDuration={NOTIF_TRANSITION_DURATION}
      child={NotifInner}
    ></revealer>
  );

  idle(() => {
    (RevealerWrapper as Gtk.Revealer).revealChild = true;
  });

  return RevealerWrapper;
}
