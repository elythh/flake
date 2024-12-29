import { Gtk, Astal, App } from "astal/gtk3";
import { PopupWindow } from "../PopupWindow";
import { Speaker, MicToggle } from "./components/Audio";
import NetworkInfo from "./components/NetworkInfo";
import BluetoothInfo from "./components/BluetoothInfo";
import DoNotDisturb from "./components/DoNotDisturb";
import NotifCentre from "./components/NotifCentre";
import Media from "./components/Media";
import { USER } from "../../shared/constants";
import { Variable } from "astal";

export default function Panel() {
  const anchor = Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT;

  const Toggles = (
    <box spacing={12} homogeneous>
      <box spacing={12} vertical>
        <BluetoothInfo />
        <DoNotDisturb />
      </box>
      <box spacing={12} vertical>
        <NetworkInfo />
        <MicToggle />
      </box>
    </box>
  );

  const showNotifCentre = Variable(false);

  return (
    <PopupWindow
      name="panel"
      application={App}
      transition={Gtk.RevealerTransitionType.SLIDE_DOWN}
      anchor={anchor}
      keymode={Astal.Keymode.ON_DEMAND}
    >
      <box vertical css={"padding: 6px"}>
        <box className="panel-box" vertical={true}>
          <centerbox
            className={"header"}
            startWidget={
              <label halign={Gtk.Align.START} label={`Hi ${USER}`} />
            }
            heightRequest={24}
            endWidget={
              <button
                className={"nc-toggle"}
                cursor={"pointer"}
                heightRequest={24}
                widthRequest={24}
                halign={Gtk.Align.END}
                onClicked={() => showNotifCentre.set(!showNotifCentre.get())}
                onDestroy={() => showNotifCentre.drop()}
              >
                <icon icon={"notification-symbolic"} css={"font-size: 14px;"} />
              </button>
            }
          />
          <box spacing={12} className={"pb-lower"} vertical>
            {Toggles}
            <Speaker />
            <Media />
          </box>
        </box>
        <revealer
          revealChild={showNotifCentre()}
          transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
        >
          <NotifCentre />
        </revealer>
      </box>
    </PopupWindow>
  );
}
