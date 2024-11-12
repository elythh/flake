import AstalNotifd from "gi://AstalNotifd";
import { Gtk, Astal } from "astal/gtk3";
import { timeout, idle } from "astal";

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

export const NOTIF_TRANSITION_DURATION = 300;

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

  const CloseButton = (
    <button
      className={"close-button"}
      onClicked={() => notif.dismiss()}
      halign={Gtk.Align.END}
    >
      <icon icon={"window-close-symbolic"} />
    </button>
  );

  const Header = (
    <centerbox
      className={"header"}
      startWidget={Title}
      endWidget={CloseButton}
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
    <box className={`notification ${notif.urgency}`} vertical={true}>
      {Header}
      <box>
        {NotifIcon(notif)}
        <box className="left" vertical={true} valign={Gtk.Align.CENTER}>
          {Body}
          {Actions}
        </box>
      </box>
    </box>
  );

  const InnerRevealer = (
    <revealer
      transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
      transitionDuration={NOTIF_TRANSITION_DURATION}
    >
      {NotifInner}
    </revealer>
  );

  const OuterRevealer = (
    <revealer
      name={notif.id.toString()}
      transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
      transitionDuration={NOTIF_TRANSITION_DURATION}
    >
      {InnerRevealer}
    </revealer>
  );

  idle(() => {
    (OuterRevealer as Gtk.Revealer).revealChild = true;
    timeout(NOTIF_TRANSITION_DURATION, () => {
      (InnerRevealer as Gtk.Revealer).revealChild = true;
    });
  });

  return OuterRevealer;
}
