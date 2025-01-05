import { Gdk, App, Gtk } from "astal/gtk3";
import Tray from "gi://AstalTray";
import { bind, Variable } from "astal";

export default function SysTray() {
  const tray = Tray.get_default();
  const showSysTray = Variable(false);

  const TrayItems = (
    <revealer
      revealChild={showSysTray()}
      transitionDuration={200}
      className="tray-items"
      transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
    >
      <box>
        {bind(tray, "items").as((items) =>
          items.map((item) => {
            if (item.iconThemePath) App.add_icons(item.iconThemePath);

            return (
              <menubutton
                tooltipMarkup={bind(item, "tooltipMarkup")}
                usePopover={false}
                actionGroup={bind(item, "action-group").as((ag) => [
                  "dbusmenu",
                  ag,
                ])}
                menuModel={bind(item, "menu-model")}
              >
                <icon gicon={bind(item, "gicon")} />
              </menubutton>
            );
          }),
        )}
      </box>
    </revealer>
  );
  const TrayButton = (
    <button
      className="tray-button"
      cursor={"pointer"}
      onClick={() => {
        showSysTray.set(!showSysTray.get());
      }}
    >
      <icon
        icon="pan-start-symbolic"
        className={showSysTray((showing) => (showing ? "showing" : ""))}
      />
    </button>
  );

  return (
    <box className={"tray"}>
      {TrayItems}
      {TrayButton}
    </box>
  );
}
