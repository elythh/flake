import { togglePopupWindow } from "../../PopupWindow";
import { WINDOW_NAME } from "../../launcher";

export default function LauncherButton() {
  return (
    <button
      className={"launcher-button"}
      onClicked={() => togglePopupWindow(WINDOW_NAME)}
    >
      <icon icon={"system-search-symbolic"} css="font-size: 14px;" />
    </button>
  );
}
