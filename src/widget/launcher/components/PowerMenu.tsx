import { execAsync } from "astal/process";
import { USER } from "../../../shared/constants";
import { Gtk, Widget } from "astal/gtk3";

type PowerButtonProps = Widget.ButtonProps & { cmd: string; icon: string };
function PowerButton({ cmd, icon, ...rest }: PowerButtonProps) {
  return (
    <button
      onClicked={() => execAsync(cmd)}
      heightRequest={20}
      widthRequest={20}
      {...rest}
    >
      <icon icon={icon} css="font-size: 13px" />
    </button>
  );
}

export default function PowerMenu() {
  return (
    <centerbox
      className={"power-menu"}
      start_widget={<label halign={Gtk.Align.START} label={USER} />}
      endWidget={
        <box halign={Gtk.Align.END} spacing={4}>
          <PowerButton
            cmd="hyprlock"
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
