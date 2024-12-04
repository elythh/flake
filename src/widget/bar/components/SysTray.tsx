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

            const menu = item.create_menu();
            return (
              <button
                halign={Gtk.Align.END}
                tooltipMarkup={bind(item, "tooltipMarkup")}
                onDestroy={() => menu?.destroy()}
                onClickRelease={(self) => {
                  menu?.popup_at_widget(
                    self,
                    Gdk.Gravity.SOUTH,
                    Gdk.Gravity.NORTH,
                    null,
                  );
                }}
              >
                <icon gIcon={bind(item, "gicon")} />
              </button>
            );
          }),
        )}
      </box>
    </revealer>
  );
  const TrayButton = (
    <button
      className="tray-button"
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
