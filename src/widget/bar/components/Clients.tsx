import Hyprland from "gi://AstalHyprland";
import { bind } from "astal";
import { Gtk } from "astal/gtk3";

export default function Clients() {
  const hypr = Hyprland.get_default();
  return (
    <box className={"clients"} spacing={4} hexpand={true}>
      {bind(hypr, "clients").as((clients) =>
        clients.slice(0, 10).map((client) => (
          <button
            tooltipText={bind(client, "title")}
            className={bind(hypr, "focusedClient").as((focusedClient) =>
              focusedClient?.pid === client.pid ? "focused" : "",
            )}
            onClick={() => client.focus()}
          >
            <icon
              halign={Gtk.Align.CENTER}
              icon={bind(client, "class")}
              css={"font-size: 16px;"}
            />
          </button>
        )),
      )}
    </box>
  );
}
