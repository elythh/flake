pragma ComponentBehavior: Bound

import "root:/widgets"
import "root:/services"
import "root:/config"
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property ShellScreen screen

    Layout.preferredWidth: preview.implicitWidth + Appearance.padding.large * 2
    Layout.fillHeight: true

    StyledClippingRect {
        id: preview

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: label.top
        anchors.topMargin: Appearance.padding.large
        anchors.bottomMargin: Appearance.spacing.normal

        implicitWidth: view.implicitWidth

        color: Colours.palette.m3surfaceContainer
        radius: Appearance.rounding.small

        Loader {
            anchors.centerIn: parent
            active: !Hyprland.activeClient
            asynchronous: true

            sourceComponent: ColumnLayout {
                spacing: 0

                MaterialIcon {
                    Layout.alignment: Qt.AlignHCenter
                    text: "web_asset_off"
                    color: Colours.palette.m3outline
                    font.pointSize: Appearance.font.size.extraLarge * 3
                    font.variableAxes: ({
                            opsz: Appearance.font.size.extraLarge * 3
                        })
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("No active client")
                    color: Colours.palette.m3outline
                    font.pointSize: Appearance.font.size.extraLarge
                    font.weight: 500
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Try switching to a window")
                    color: Colours.palette.m3outline
                    font.pointSize: Appearance.font.size.large
                }
            }
        }

        ScreencopyView {
            id: view

            anchors.centerIn: parent

            captureSource: Hyprland.activeClient ? ToplevelManager.activeToplevel : null
            live: true

            constraintSize.width: parent.height * Math.min(screen.width / screen.height, Hyprland.activeClient.width / Hyprland.activeClient.height)
            constraintSize.height: parent.height
        }
    }

    StyledText {
        id: label

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Appearance.padding.large

        animate: true
        text: {
            const client = Hyprland.activeClient;
            if (!client)
                return qsTr("No active client");

            const mon = Hyprland.monitors.values[Hyprland.activeClient.lastIpcObject.monitor];
            return qsTr("%1 on monitor %2 at %3, %4").arg(client.title).arg(mon.name).arg(client.x).arg(client.y);
        }
    }
}
