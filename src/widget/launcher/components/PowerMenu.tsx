import { execAsync } from "astal/process";
import { Gtk, Widget } from "astal/gtk3";

type PowerButtonProps = Widget.ButtonProps & { cmd: string; icon: string };
function PowerButton({ cmd, icon, ...rest }: PowerButtonProps) {
  return (
    <button
      onClicked={() => execAsync(cmd)}
      heightRequest={24}
      widthRequest={24}
      cursor={"pointer"}
      {...rest}
    >
      <icon icon={icon} css="font-size: 12px" />
    </button>
  );
}

export default function PowerMenu() {
  return (
    <centerbox
      className={"power-menu"}
      start_widget={
        <label heightRequest={24} halign={Gtk.Align.START} label={"Launcher"} />
      }
      endWidget={
        <box halign={Gtk.Align.END} spacing={6}>
          <PowerButton
            cmd={`ags run ${SRC}/lockscreen`}
            icon="system-lock-screen-symbolic"
            className={"lock"}
          />
          <PowerButton
            cmd="systemctl poweroff"
            icon="system-shutdown-symbolic"
            className={"poff"}
          />
        </box>
      }
    />
  );
}
