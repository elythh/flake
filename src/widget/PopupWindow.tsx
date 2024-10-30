import { App, Gtk, Widget, Gdk } from "astal/gtk3";
import { timeout } from "astal";

const TRANSITION_DURATION = 300;

export function closePopupWindow(win: Gtk.Window) {
  (win.get_child() as Gtk.Revealer).revealChild = false;
  timeout(TRANSITION_DURATION, () => win.hide());
}

export function togglePopupWindow(windowName: string) {
  const win = App.get_window(windowName)!;
  if (win.is_visible() === false) {
    win.show();
    (win.get_child() as Gtk.Revealer).revealChild = true;
  } else {
    closePopupWindow(win);
  }
}

type PopupWindowProps = Omit<Widget.WindowProps, "name"> & {
  name: string;
  transition: Gtk.RevealerTransitionType;
  child?: JSX.Element;
};

export function PopupWindow({
  name,
  transition,
  child,
  ...rest
}: PopupWindowProps) {
  return (
    <window
      name={name}
      application={App}
      visible={false}
      widthRequest={2}
      heightRequest={2}
      {...rest}
      onKeyPressEvent={(self, event) => {
        const keyVal = event.get_keyval()[1];
        if (keyVal === Gdk.KEY_Escape) {
          closePopupWindow(self);
        }
      }}
    >
      <revealer
        transitionType={transition}
        transitionDuration={TRANSITION_DURATION}
        hexpand={true}
        vexpand={true}
        child={child || <box></box>}
        revealChild={false}
      ></revealer>
    </window>
  );
}
