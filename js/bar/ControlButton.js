const audio = await Service.import("audio");
const network = await Service.import("network");

import { speakerIcon, microphoneIcon } from "../Variables.js";

const SpeakerIndicator = () =>
  Widget.Icon({
    className: "speaker",
  }).hook(
    audio,
    (self) => {
      self.icon = speakerIcon();
    },
    "speaker-changed",
  );

const MicrophoneIndicator = () =>
  Widget.Icon({
    className: "microphone",
  }).hook(
    audio,
    (self) => {
      self.icon = microphoneIcon();
    },
    "microphone-changed",
  );

/** @param {'wifi' | 'wired'} type */
const NetworkIcon = (type) =>
  Widget.Icon({
    className: "network",
    icon: network[type].bind("icon_name"),
  });

const NetworkIndicator = () =>
  Widget.Stack({
    children: {
      wifi: NetworkIcon("wifi"),
      wired: NetworkIcon("wired"),
    },
    shown: network.bind("primary").as((p) => p || "wifi"),
  });

const PowerIcon = () =>
  Widget.Icon({
    className: "power",
    icon: "system-shutdown-symbolic",
  });

export const ControlButton = () =>
  Widget.Button({
    class_name: "control-button",
    onClicked: () => App.toggleWindow("control_panel"),
    child: Widget.Box({
      // vertical: true,
      spacing: 12,
      children: [SpeakerIndicator(), MicrophoneIndicator(), NetworkIndicator(), PowerIcon()],
    }),
  });
