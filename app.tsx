import { App } from "astal/gtk3";
import Bar from "./src/widget/bar";
import Launcher from "./src/widget/launcher";
import NotificationPopups from "./src/widget/notifs/popups";
import Panel from "./src/widget/panel";

import { togglePopupWindow } from "./src/widget/PopupWindow";

import { exec } from "astal/process";

const style = `${SRC}/style.scss`
const target = "/tmp/style.css";

exec(`sass ${style} ${target}`);

App.start({
  instanceName: "shell",
  icons: `${SRC}/assets/icons`,
  requestHandler(req, res) {
    const [cmd, ...args] = req.split(" ");
    if (cmd == "toggle-popup") {
      togglePopupWindow(args[0]);
      res("");
    }
  },
  css: target,
  main() {
    App.get_monitors().map((mon, i) => Bar(mon, i));
    Launcher();
    NotificationPopups();
    Panel();
  },
});
