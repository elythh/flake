import "root:/widgets"
import "root:/services"
import "root:/config"
import Quickshell
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    anchors.fill: parent
    spacing: Appearance.spacing.small

    Label {
        Layout.topMargin: Appearance.padding.large * 2

        text: Hyprland.activeClient?.title ?? "No active client"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere

        font.pointSize: Appearance.font.size.large
        font.weight: 500
    }

    Label {
        text: Hyprland.activeClient?.wmClass ?? "No active client"
        color: Colours.palette.m3tertiary

        font.pointSize: Appearance.font.size.larger
    }

    StyledRect {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        Layout.leftMargin: Appearance.padding.large * 2
        Layout.rightMargin: Appearance.padding.large * 2
        Layout.topMargin: Appearance.spacing.normal
        Layout.bottomMargin: Appearance.spacing.large

        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "location_on"
        text: qsTr("Address: %1").arg(Hyprland.activeClient?.address ?? "unknown")
        color: Colours.palette.m3primary
    }

    Detail {
        icon: "location_searching"
        text: qsTr("Position: %1, %2").arg(Hyprland.activeClient?.x ?? -1).arg(Hyprland.activeClient?.y ?? -1)
    }

    Detail {
        icon: "resize"
        text: qsTr("Size: %1 x %2").arg(Hyprland.activeClient?.width ?? -1).arg(Hyprland.activeClient?.height ?? -1)
        color: Colours.palette.m3tertiary
    }

    Detail {
        icon: "workspaces"
        text: qsTr("Workspace: %1 (%2)").arg(Hyprland.activeClient?.workspace.name ?? -1).arg(Hyprland.activeClient?.workspace.id ?? -1)
        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "desktop_windows"
        text: {
            const mon = Hyprland.activeClient?.monitor;
            if (mon)
                return qsTr("Monitor: %1 (%2) at %3, %4").arg(mon.name).arg(mon.id).arg(mon.x).arg(mon.y);
            return qsTr("Monitor: unknown");
        }
    }

    Detail {
        icon: "page_header"
        text: qsTr("Initial title: %1").arg(Hyprland.activeClient?.initialTitle ?? "unknown")
        color: Colours.palette.m3tertiary
    }

    Detail {
        icon: "category"
        text: qsTr("Initial class: %1").arg(Hyprland.activeClient?.initialClass ?? "unknown")
    }

    Detail {
        icon: "account_tree"
        text: qsTr("Process id: %1").arg(Hyprland.activeClient?.pid ?? -1)
        color: Colours.palette.m3primary
    }

    Detail {
        icon: "picture_in_picture_center"
        text: qsTr("Floating: %1").arg(Hyprland.activeClient?.floating ? "yes" : "no")
        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "gradient"
        text: qsTr("Xwayland: %1").arg(Hyprland.activeClient?.lastIpcObject.xwayland ? "yes" : "no")
    }

    Detail {
        icon: "keep"
        text: qsTr("Pinned: %1").arg(Hyprland.activeClient?.lastIpcObject.pinned ? "yes" : "no")
        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "fullscreen"
        text: {
            const fs = Hyprland.activeClient?.fullscreen;
            if (fs)
                return qsTr("Fullscreen state: %1").arg(fs == 0 ? "off" : fs == 1 ? "maximised" : "on");
            return qsTr("Fullscreen state: unknown");
        }
        color: Colours.palette.m3tertiary
    }

    Item {
        Layout.fillHeight: true
    }

    component Detail: RowLayout {
        id: detail

        required property string icon
        required property string text
        property alias color: icon.color

        Layout.leftMargin: Appearance.padding.large
        Layout.rightMargin: Appearance.padding.large
        Layout.fillWidth: true

        spacing: Appearance.spacing.normal

        MaterialIcon {
            id: icon

            Layout.alignment: Qt.AlignVCenter
            text: detail.icon
        }

        StyledText {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            text: detail.text
            elide: Text.ElideRight
            font.pointSize: Appearance.font.size.normal
        }
    }

    component Label: StyledText {
        Layout.leftMargin: Appearance.padding.large
        Layout.rightMargin: Appearance.padding.large
        Layout.fillWidth: true
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        animate: true
    }
}
