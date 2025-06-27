import "root:/widgets"
import "root:/services"
import "root:/config"
import QtQuick.Layouts

ColumnLayout {
    id: root

    spacing: 0

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: Appearance.spacing.small

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            text: Time.format("HH")
            color: Colours.palette.m3secondary
            font.pointSize: Appearance.font.size.extraLarge * 4
            font.family: Appearance.font.family.mono
            font.weight: 800
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            text: ":"
            color: Colours.palette.m3primary
            font.pointSize: Appearance.font.size.extraLarge * 4
            font.family: Appearance.font.family.mono
            font.weight: 800
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            text: Time.format("mm")
            color: Colours.palette.m3secondary
            font.pointSize: Appearance.font.size.extraLarge * 4
            font.family: Appearance.font.family.mono
            font.weight: 800
        }
    }

    StyledText {
        Layout.alignment: Qt.AlignHCenter
        Layout.bottomMargin: Appearance.padding.large * 3

        text: Time.format("dddd, d MMMM yyyy")
        color: Colours.palette.m3tertiary
        font.pointSize: Appearance.font.size.extraLarge
        font.family: Appearance.font.family.mono
        font.bold: true
    }
}
