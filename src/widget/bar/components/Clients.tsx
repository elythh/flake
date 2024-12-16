import Hyprland from "gi://AstalHyprland";
import { bind } from "astal";
import { Gtk } from "astal/gtk3";
import Pango from "gi://Pango";

export default function Clients() {
  const hypr = Hyprland.get_default();

  return bind(hypr, "focused_workspace").as((workspace) => (
    <box spacing={8} className={"clients"}>
      {bind(workspace, "clients").as((clients) =>
        clients.slice(0, 8).map((client) => (
          <button
            className={bind(hypr, "focusedClient").as((focusedClient) =>
              focusedClient?.address === client.address ? "focused" : "",
            )}
            onClick={() => client.focus()}
          >
            <box spacing={8}>
              <icon
                halign={Gtk.Align.CENTER}
                icon={bind(client, "class").as(c => c.toLowerCase())}
                css={"font-size: 16px;"}
              />
              <label
                label={bind(client, "title")}
                max_width_chars={18}
                ellipsize={Pango.EllipsizeMode.END}
              />
            </box>
          </button>
        )),
      )}
    </box>
  ));
}
