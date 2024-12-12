// Most of this code is taken from https://github.com/Aylur/astal/blob/main/examples/js/media-player/widget/MediaPlayer.tsx
import { Gtk } from "astal/gtk3";
import Mpris from "gi://AstalMpris";
import Pango from "gi://Pango";
import { bind } from "astal";

function Player({ player }: { player: Mpris.Player | null }) {
  const title = player
    ? bind(player, "title").as((t) => t || "Unknown Track")
    : "Nothing Playing";

  const artist = player
    ? bind(player, "artist").as((a) => a || "Unknown Artist")
    : "...";

  return (
    <box className={"media-player"} hexpand>
      {/* Icon/ Cover Art (This code is ###)*/}
      {player ? (
        <box
          className={"cover-art"}
          css={bind(player, "coverArt").as(
            (c) => `background-image: url('${c}')`,
          )}
        />
      ) : (
        <centerbox
          className={"music-icon"}
          centerWidget={
            <icon
              icon="emblem-music-symbolic"
              css={"font-size: 38px;"}
              valign={Gtk.Align.CENTER}
              halign={Gtk.Align.CENTER}
            />
          }
        />
      )}
      <box
        className={"mp-right"}
        vertical
        valign={Gtk.Align.CENTER}
        spacing={12}
      >
        <box vertical>
          <label
            ellipsize={Pango.EllipsizeMode.END}
            maxWidthChars={18}
            halign={Gtk.Align.START}
            label={title}
            tooltipText={title}
            className={"title"}
          />
          <label
            ellipsize={Pango.EllipsizeMode.END}
            maxWidthChars={18}
            hexpand
            halign={Gtk.Align.START}
            label={artist}
            className={"artist"}
          />
        </box>
        {player ? (
          <box vertical spacing={8}>
            <slider
              hexpand
              visible={bind(player, "length").as((length) => length > 0)}
              onDragged={({ value }) =>
                (player.position = value * player.length)
              }
              value={bind(player, "position").as((p) =>
                player.length > 0 ? p / player.length : 0,
              )}
            />
            <centerbox
              className="actions"
              centerWidget={
                <box spacing={8}>
                  <button
                    onClicked={() => player.previous()}
                    visible={bind(player, "canGoPrevious")}
                  >
                    <icon icon="media-skip-backward-symbolic" />
                  </button>
                  <button
                    onClicked={() => player.play_pause()}
                    visible={bind(player, "canControl")}
                  >
                    <icon
                      icon={bind(player, "playbackStatus").as((s) =>
                        s === Mpris.PlaybackStatus.PLAYING
                          ? "media-playback-pause-symbolic"
                          : "media-playback-start-symbolic",
                      )}
                    />
                  </button>
                  <button
                    onClicked={() => player.next()}
                    visible={bind(player, "canGoNext")}
                  >
                    <icon icon="media-skip-forward-symbolic" />
                  </button>
                </box>
              }
            />
          </box>
        ) : null}
      </box>
    </box>
  );
}

export default function Media() {
  const mpris = Mpris.get_default();
  return (
    <box>
      {bind(mpris, "players").as((players) => (
        <Player player={players[0]} />
      ))}
    </box>
  );
}
