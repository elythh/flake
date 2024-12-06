import Wp from "gi://AstalWp";
import { bind } from "astal";
import { Gtk } from "astal/gtk3";

export function Speaker() {
  const speaker = Wp.get_default()?.default_speaker!;

  return (
    <eventbox
      valign={Gtk.Align.END}
      onScroll={(_, event) => {
        if (event.delta_y < 0) {
          speaker.volume = Math.min(speaker.volume + 0.03, 1);
        } else if (event.delta_y > 0) {
          speaker.volume = Math.max(speaker.volume - 0.03, 0);
        }
      }}
    >
      <box
        className="speaker-slider"
        hexpand={true}
        heightRequest={30}
        spacing={12}
      >
        <icon icon={bind(speaker, "volumeIcon")} css={"font-size: 13px;"} />
        <slider
          hexpand={true}
          onDragged={({ value }) => (speaker.volume = value)}
          value={bind(speaker, "volume")}
        />
      </box>
    </eventbox>
  );
}
