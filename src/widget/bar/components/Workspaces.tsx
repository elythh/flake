import Hyprland from "gi://AstalHyprland";
import Gtk from "gi://Gtk?version=3.0";

export default function Workspaces() {
  const hypr = Hyprland.get_default();

  return (
    <centerbox
      className="workspaces"
      center_widget={
        <box spacing={2}>
          {Array.from({ length: 5 }, (_, i) => i + 1).map((i) => (
            <button
              cursor={"pointer"}
              valign={Gtk.Align.CENTER}
              setup={(self) => {
                self.hook(hypr, "event", () => {
                  self.toggleClassName(
                    "active",
                    hypr.focusedWorkspace.id === i,
                  );
                  self.toggleClassName(
                    "occupied",
                    (hypr.get_workspace(i)?.get_clients().length || 0) > 0,
                  );
                });
              }}
              onClick={() =>
                hypr.message_async(`dispatch workspace ${i}`, null)
              }
            >
              <box
                expand={false}
                halign={Gtk.Align.CENTER}
                valign={Gtk.Align.CENTER}
              />
            </button>
          ))}
        </box>
      }
    />
  );
}
