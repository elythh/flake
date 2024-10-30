import Wp from "gi://AstalWp";
import { bind } from "astal";

export default function Audio() {
  const speaker = Wp.get_default()?.default_speaker!;
  return (
    <eventbox
      onScroll={(_, event) => {
        if (event.delta_y < 0) {
          speaker.volume = Math.min(speaker.volume + 0.03, 1);
        } else if (event.delta_y > 0) {
          speaker.volume = Math.max(speaker.volume - 0.03, 0);
        }
      }}
    >
      <box className="audio-slider" css="min-width: 140px">
        <icon icon={bind(speaker, "volumeIcon")} />
        <slider
          hexpand
          onDragged={({ value }) => (speaker.volume = value)}
          value={bind(speaker, "volume")}
        />
      </box>
    </eventbox>
  );
}
