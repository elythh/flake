import { Astal } from "astal/gtk3";
import { bind } from "astal";
import {WIDTH, NotifMap} from "../../notifs/NotifMap";

export default function NotificationPopups(monitor = 0) {
  const notifs = new NotifMap();

  const NotifList = (
    <box
      widthRequest={WIDTH}
      vertical={true}
      className={"notifications"}
    >
      {bind(notifs)}
    </box>
  );

  const anchor = Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT;

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
