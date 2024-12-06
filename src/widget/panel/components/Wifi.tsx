import WifiIcon from "../../../shared/WifiIcon";

export default function Wifi() {
  return (
    <centerbox
      className="wifi"
      heightRequest={30}
      widthRequest={30}
      centerWidget={WifiIcon()}
    ></centerbox>
  );
}
