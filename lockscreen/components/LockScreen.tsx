import AstalAuth from "gi://AstalAuth";
import { Astal, Gdk, Gtk } from "astal/gtk3";
import { Variable, bind } from "astal";
import Header from "./Header";

type Props = {
  pam: AstalAuth.Pam;
  monitor: Gdk.Monitor;
  authenticationFailure: Variable<boolean>;
};
export default function LockScreen(lockScreenProps: Props) {
  const { pam, monitor, authenticationFailure } = lockScreenProps;

  const anchor =
    Astal.WindowAnchor.TOP |
    Astal.WindowAnchor.RIGHT |
    Astal.WindowAnchor.BOTTOM |
    Astal.WindowAnchor.LEFT;

  return (
    <window
      gdkmonitor={monitor}
      visible={false}
      anchor={anchor}
      className={"lock-screen"}
    >
      <box
        expand={false}
        valign={Gtk.Align.CENTER}
        halign={Gtk.Align.CENTER}
        heightRequest={200}
        widthRequest={600}
        vertical
        className={"main-box"}
      >
        <Header />
        <box className={"bot"} expand spacing={32}>
          <box
            heightRequest={180}
            widthRequest={180}
            valign={Gtk.Align.CENTER}
            halign={Gtk.Align.CENTER}
            expand={false}
            className={"pfp"}
            css={`
              background-image: url("${SRC}/assets/pfp.jpg");
            `}
          />
          <box
            vertical
            spacing={12}
            className={"ls-right"}
            vexpand={false}
            valign={Gtk.Align.CENTER}
          >
            <box spacing={8}>
              <icon icon={"user-available-symbolic"} />
              <label
                label={bind(pam, "username")}
                hexpand
                halign={Gtk.Align.START}
              />
            </box>
            <entry
              visibility={false}
              className={"password-entry"}
              placeholderText={"Password ..."}
              onActivate={(self) => {
                pam.supply_secret(self.text);
                self.set_text("");
              }}
            />
            <label
              hexpand
              className={"auth-fail"}
              halign={Gtk.Align.START}
              label={bind(authenticationFailure).as((f) =>
                f ? "Authentication Failure" : "",
              )}
            />
          </box>
        </box>
      </box>
    </window>
  );
}
