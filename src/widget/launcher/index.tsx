import { PopupWindow, togglePopupWindow } from "../PopupWindow";
import { App, Astal, Gtk } from "astal/gtk3";
import Apps from "gi://AstalApps";
import PowerMenu from "./components/PowerMenu";

export const WINDOW_NAME = "app-launcher";

function ApplicationItem(application: Apps.Application) {
  return (
    <button
      className="app-entry"
      heightRequest={38}
      name={application.name}
      onClicked={() => {
        togglePopupWindow(WINDOW_NAME);
        application.launch();
      }}
    >
      <box>
        <icon icon={application.iconName} css={"font-size: 26px"} />
        <label
          className="title"
          label={application.name}
          valign={Gtk.Align.CENTER}
        ></label>
      </box>
    </button>
  );
}

type InnerProps = { width: number; height: number; spacing: number };

// Idiot
// This works for me since I barely have any apps installed
// Also for some reason fuzzy_match() does not exist
// TODO: Fix this garbage
function Inner({ width, height, spacing }: InnerProps) {
  const apps = Apps.Apps.new();

  const applications = apps.fuzzy_query("");
  const applicationBtns = applications.map(ApplicationItem);

  const List = (
    <box vertical={true} spacing={spacing}>
      {applicationBtns}
    </box>
  );

  const Search = (
    <entry
      className="search"
      heightRequest={38}
      hexpand={true}
      onActivate={(self) => {
        const results = apps.fuzzy_query(self.text);
        if (results[0]) {
          togglePopupWindow(WINDOW_NAME);
          results[0].launch();
        }
      }}
      onChanged={(self) => {
        // Horrifying
        const results = apps.fuzzy_query(self.text).map((itm) => itm.name);
        applicationBtns.forEach((itm) => {
          itm.set_visible(results.includes(itm.name));
        });
      }}
    />
  );

  App.connect("window-toggled", (_, win) => {
    if (win.name === WINDOW_NAME) {
      (Search as Gtk.Entry).set_text("");
      (Search as Gtk.Entry).grab_focus();
    }
  });

  return (
    <box className={"launcher-box"}>
      <PowerMenu />
      <box
        vertical={true}
        spacing={spacing}
        children={[
          Search,
          <scrollable
            widthRequest={width}
            heightRequest={height}
            hscroll={Gtk.PolicyType.NEVER}
            child={List}
          ></scrollable>,
        ]}
      ></box>
    </box>
  );
}

export default function Launcher() {
  const anchor = Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.LEFT;
  return (
    <PopupWindow
      name={WINDOW_NAME}
      transition={Gtk.RevealerTransitionType.SLIDE_UP}
      anchor={anchor}
      keymode={Astal.Keymode.EXCLUSIVE}
      monitor={0}
    >
      <box>
        <Inner width={300} height={380} spacing={8} />
      </box>
    </PopupWindow>
  );
}
