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

export const panelShown = Variable("quick-settings");

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

  const QuickSettings = (
    <box className="quick-settings" vertical={true} name={"quick-settings"}>
      <centerbox
        className={"header"}
        startWidget={<label halign={Gtk.Align.START} label={`Hi ${USER}`} />}
        heightRequest={24}
        endWidget={
          <button
            className={"nc-toggle"}
            cursor={"pointer"}
            heightRequest={24}
            widthRequest={24}
            halign={Gtk.Align.END}
            onClick={() => panelShown.set("notif-centre")}
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
  );

  return (
    <PopupWindow
      name="panel"
      application={App}
      transition={Gtk.RevealerTransitionType.SLIDE_DOWN}
      anchor={anchor}
      keymode={Astal.Keymode.ON_DEMAND}
    >
      <stack
        shown={panelShown()}
        transitionType={Gtk.StackTransitionType.SLIDE_RIGHT}
        transitionDuration={300}
      >
        {QuickSettings}
        <NotifCentre />
      </stack>
    </PopupWindow>
  );
}
