import { execAsync } from "astal/process";
import { Gtk } from "astal/gtk3";

type PowerButtonProps = { cmd: string; icon: string };
function PowerButton({ cmd, icon }: PowerButtonProps) {
  return (
    <button
      onClicked={() => execAsync(cmd)}
      heightRequest={38}
      widthRequest={38}
    >
      <icon icon={icon} css="font-size: 16px" />
    </button>
  );
}

export default function PowerMenu() {
  const menu = (
    <box valign={Gtk.Align.END} vertical={true} spacing={8}>
      <PowerButton cmd="hyprlock" icon="system-lock-screen-symbolic" />
      <PowerButton
        cmd={`bash -c "loginctl terminate-user $USER"`}
        icon="application-exit-symbolic"
      />
      <PowerButton cmd="systemctl reboot" icon="system-reboot-symbolic" />
      <PowerButton cmd="systemctl poweroff" icon="system-shutdown-symbolic" />
    </box>
  );
  const pfp = (
    <box
      valign={Gtk.Align.START}
      heightRequest={38}
      widthRequest={38}
      css={`
        background-image: url("${SRC}/assets/pfp.png");
        background-size: cover;
        border-radius: 25px;
      `}
    />
  );
  return (
    <centerbox
      className={"power-menu"}
      vertical={true}
      startWidget={pfp}
      endWidget={menu}
    ></centerbox>
  );
}
