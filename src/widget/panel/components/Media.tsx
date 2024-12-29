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
    <box className={"media-player"} hexpand heightRequest={60}>
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
              css={"font-size: 14px;"}
              valign={Gtk.Align.CENTER}
              halign={Gtk.Align.CENTER}
            />
          }
        />
      )}
      <box className={"mp-right"} valign={Gtk.Align.CENTER} spacing={12}>
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
        {player && (
          <box
            vertical
            spacing={8}
            valign={Gtk.Align.CENTER}
            className={"actions"}
          >
            {
              <box spacing={8}>
                <button
                  onClicked={() => player.previous()}
                  visible={bind(player, "canGoPrevious")}
                  cursor={"pointer"}
                >
                  <icon icon="media-skip-backward-symbolic" />
                </button>
                <button
                  onClicked={() => player.play_pause()}
                  visible={bind(player, "canControl")}
                  className={"pause-play"}
                  cursor={"pointer"}
                >
                  <circularprogress
                    className={"progress"}
                    startAt={0.75}
                    endAt={0.75}
                    rounded
                    value={bind(player, "position").as((p) =>
                      player.length > 0 ? p / player.length : 0,
                    )}
                  >
                    <icon
                      icon={bind(player, "playbackStatus").as((s) =>
                        s === Mpris.PlaybackStatus.PLAYING
                          ? "media-playback-pause-symbolic"
                          : "media-playback-start-symbolic",
                      )}
                    />
                  </circularprogress>
                </button>
                <button
                  onClicked={() => player.next()}
                  visible={bind(player, "canGoNext")}
                  cursor={"pointer"}
                >
                  <icon icon="media-skip-forward-symbolic" />
                </button>
              </box>
            }
          </box>
        )}
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
