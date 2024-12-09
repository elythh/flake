// Referenced from https://github.com/gitmeED331/agsv2/blob/main/Lockscreen/app.tsx

import Lock from "gi://GtkSessionLock";
import AstalAuth from "gi://AstalAuth";
import LockScreen from "./components/LockScreen";
import { App, Gdk, Gtk } from "astal/gtk3";
import { timeout } from "astal";
import { Variable } from "astal";

import { writeFile } from "astal/file";
import { exec } from "astal/process";
import { HOME } from "../shared/constants";

const colorsPath = `${HOME}/.config/ags_res/colors.scss`;
const tmpscss = "/tmp/ags_lockscreen.scss";
const target = "/tmp/ags_lockscreen.css";

import lockScreenStyle from "inline:./scss/lockscreen.scss";

function main() {
  if (!Lock.is_supported()) {
    print("Gtk Session Lock is not supported");
    App.quit();
  }

  const pam = new AstalAuth.Pam();
  const sessionLock = Lock.prepare_lock();
  const lockScreens = new Map<Gdk.Monitor, Gtk.Widget>();
  const authenticationFailure = Variable(false);

  sessionLock.connect("locked", () => {
    pam.start_authenticate();
  });

  sessionLock.connect("finished", () => {
    sessionLock.destroy();
    lockScreens.forEach((window, _) => {
      window.destroy();
    });
    Gdk.Display.get_default()?.sync();
    authenticationFailure.drop();
    App.quit();
  });

  pam.connect("success", () => {
    timeout(500, () => {
      sessionLock.unlock_and_destroy();
      lockScreens.forEach((window, _) => {
        window.destroy();
      });
      Gdk.Display.get_default()?.sync();
      authenticationFailure.drop();
      App.quit();
    });
  });

  pam.connect("fail", () => {
    authenticationFailure.set(true);
    pam.start_authenticate();
  });

  // Docs say I should call the supply_secret() method but
  pam.connect("auth-info", () => {
    pam.supply_secret(null);
  });
  pam.connect("auth-error", () => {
    pam.supply_secret(null);
  });
  pam.connect("auth-prompt-hidden", () => {
    print("Prompt Hidden");
  });
  pam.connect("auth-prompt-visible", () => {
    print("Prompt Visible");
  });

  sessionLock.lock_lock();

  for (const gdkmonitor of App.get_monitors()) {
    const lockScreen = LockScreen({
      pam: pam,
      monitor: gdkmonitor,
      authenticationFailure: authenticationFailure,
    }) as Gtk.Window;

    lockScreens.set(gdkmonitor, lockScreen);

    sessionLock.new_surface(lockScreen, gdkmonitor);

    lockScreen.show();
  }

  App.connect("monitor-added", (_, gdkmonitor) => {
    const lockScreen = LockScreen({
      pam: pam,
      monitor: gdkmonitor,
      authenticationFailure: authenticationFailure,
    }) as Gtk.Window;

    lockScreens.set(gdkmonitor, lockScreen);

    sessionLock.new_surface(lockScreen, gdkmonitor);

    lockScreen.show();
  });

  App.connect("monitor-removed", (_, gdkmonitor) => {
    lockScreens.get(gdkmonitor)?.destroy();
    lockScreens.delete(gdkmonitor);
  });
}

writeFile(
  tmpscss,
  `
  @import "${colorsPath}";
  ${lockScreenStyle}
`,
);

exec(`sass ${tmpscss} ${target}`);

App.start({
  instanceName: "lockscreen",
  css: target,
  main,
});
