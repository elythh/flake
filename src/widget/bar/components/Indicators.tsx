import Wp from "gi://AstalWp";
import { bind } from "astal";
import { togglePopupWindow } from "../../PopupWindow";
import { NetworkIcon } from "../../../shared/NetworkUtils";
import Bluetooth from "gi://AstalBluetooth";

export default function Indicators() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker!;
  const bluetooth = Bluetooth.get_default();

  return (
    <button
      className="indicators"
      onClicked={() => togglePopupWindow("panel")}
      cursor={"pointer"}
    >
      <box spacing={8}>
        <icon icon={bind(speaker, "volumeIcon")} css={"font-size: 13px"} />
        <icon
          icon={bind(bluetooth, "is_powered").as((powered) =>
            powered
              ? "bluetooth-active-symbolic"
              : "bluetooth-disabled-symbolic",
          )}
          css={"font-size: 13px"}
        />
        {NetworkIcon()}
      </box>
    </button>
  );
}
