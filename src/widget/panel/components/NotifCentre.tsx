import { Gtk } from "astal/gtk3";
import { bind } from "astal";
import { WIDTH, NotifMap } from "../../notifs/NotifMap";
import AstalNotifd from "gi://AstalNotifd";
import { panelShown } from "..";

export default function NotifCentre() {
  const notifs = new NotifMap(true);
  const notifd = AstalNotifd.get_default();

  const NotifScroll = (
    <scrollable
      name={"notif-scroll"}
      heightRequest={280}
      widthRequest={WIDTH}
      hscroll={Gtk.PolicyType.NEVER}
    >
      <box vertical={true} className={"notifications"}>
        {bind(notifs)}
      </box>
    </scrollable>
  );

  const NoNotifs = (
    <centerbox
      vexpand
      widthRequest={WIDTH}
      name={"no-notifs"}
      centerWidget={
        <box
          vertical
          expand={false}
          spacing={8}
          className={"no-notifs"}
          valign={Gtk.Align.CENTER}
        >
          <icon icon={"notification-symbolic"} css={"font-size: 38px"} />
          <label label={"No Notifications"} />
        </box>
      }
    />
  );

  const ClearButton = (
    <button
      className={"clear-button"}
      cursor={"pointer"}
      heightRequest={24}
      widthRequest={24}
      halign={Gtk.Align.END}
      onClicked={() => {
        const notifs = notifd.get_notifications();

        for (const n of notifs) {
          notifd.get_notification(n.id).dismiss();
        }
      }}
    >
      <icon icon={"clear-all-symbolic"} css={"font-size: 14px;"} />
    </button>
  );

  const QsToggle = (
    <button
      className={"qs-toggle"}
      cursor={"pointer"}
      heightRequest={24}
      widthRequest={24}
      halign={Gtk.Align.END}
      onClicked={() => {
        panelShown.set("quick-settings");
      }}
    >
      <icon icon={"multimedia-equalizer-symbolic"} css={"font-size: 14px;"} />
    </button>
  );
  return (
    <box className={"notif-centre"} vertical={true} name={"notif-centre"}>
      <centerbox
        className={"nc-header"}
        startWidget={
          <label
            heightRequest={24}
            label={"Notifications"}
            halign={Gtk.Align.START}
          />
        }
        endWidget={
          <box spacing={6} halign={Gtk.Align.END}>
            {QsToggle}
            {ClearButton}
          </box>
        }
      />
      <stack
        shown={bind(notifs).as((ns) =>
          ns.length > 0 ? "notif-scroll" : "no-notifs",
        )}
      >
        {NotifScroll}
        {NoNotifs}
      </stack>
    </box>
  );
}
