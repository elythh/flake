import Wp from "gi://AstalWp";
import { bind } from "astal";
import { Gtk } from "astal/gtk3";
import Toggle from "./shared/Toggle";

export function Speaker() {
  const speaker = Wp.get_default()?.defaultSpeaker!;

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
      <centerbox
        className="speaker-slider"
        vertical
        heightRequest={60}
        startWidget={
          <label
            label={"Volume"}
            halign={Gtk.Align.START}
            valign={Gtk.Align.START}
          />
        }
        endWidget={
          <box spacing={8} valign={Gtk.Align.END}>
            <icon icon={bind(speaker, "volumeIcon")} css={"font-size: 13px;"} />
            <slider
              hexpand
              onDragged={({ value }) => (speaker.volume = value)}
              value={bind(speaker, "volume")}
            />
            <label
              label={bind(speaker, "volume").as(
                (vol) => `${Math.floor(vol * 100)}%`,
              )}
              widthRequest={32}
            />
          </box>
        }
      />
    </eventbox>
  );
}

export function MicToggle() {
  const mic = Wp.get_default()?.defaultMicrophone!;

  return (
    <Toggle
      title="Microphone"
      clicked={() => mic.set_mute(!mic.get_mute())}
      info={
        <box spacing={8} valign={Gtk.Align.END} halign={Gtk.Align.START}>
          <icon
            icon={bind(mic, "mute").as((mute) =>
              mute
                ? "audio-input-microphone-muted-symbolic"
                : "audio-input-microphone-high-symbolic",
            )}
          />
          <label
            label={bind(mic, "mute").as((mute) => (mute ? "Muted" : "Unmuted"))}
          />
        </box>
      }
      className={bind(mic, "mute").as((mute) =>
        mute ? "info " : "info active",
      )}
    />
  );
}
