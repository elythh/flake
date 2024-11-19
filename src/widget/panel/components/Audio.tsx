import Wp from "gi://AstalWp";
import { bind } from "astal";
import { Gtk } from "astal/gtk3";

export default function Audio() {
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
      <box className="audio-slider"
        vertical={true}
        heightRequest={150}
      >
        <slider
          vexpand={true}
          vertical={true}
          inverted={true}
          onDragged={({ value }) => (speaker.volume = value)}
          value={bind(speaker, "volume")}
        />
        <icon icon={bind(speaker, "volumeIcon")} />
      </box>
    </eventbox>
  );
}
