import { HOME } from "./src/shared/constants";

import { App } from "astal/gtk3";
import Bar from "./src/widget/bar";
import Launcher from "./src/widget/launcher";
import NotificationPopups from "./src/widget/notifs/popups";
import Panel from "./src/widget/panel";
import { togglePopupWindow } from "./src/widget/PopupWindow";

import { writeFile } from "astal/file";
import { exec } from "astal/process";

import barStyle from "inline:./scss/bar.scss";
import notifStyle from "inline:./scss/notif.scss";
import launcherStyle from "inline:./scss/launcher.scss";
import panelStyle from "inline:./scss/panel.scss";
import sharedStyle from "inline:./scss/shared.scss";

const colorsPath = `${HOME}/.config/ags_res/colors.scss`;
const tmpscss = "/tmp/style.scss";
const target = "/tmp/style.css";

// Insanity

writeFile(
  tmpscss,
  `
  @import "${colorsPath}";

  ${sharedStyle}
  ${barStyle}
  ${panelStyle}
  ${notifStyle}
  ${launcherStyle}
`,
);

exec(`sass ${tmpscss} ${target}`);

App.start({
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
    App.get_monitors().map(Bar);
    Launcher();
    NotificationPopups();
    Panel();
  },
});
