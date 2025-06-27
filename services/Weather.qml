pragma Singleton

import "root:/config"
import "root:/utils"
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string loc
    property string icon
    property string description
    property real temperature

    function reload(): void {
        if (Config.dashboard.weatherLocation)
            loc = Config.dashboard.weatherLocation;
        else
            ipProc.running = true;
    }

    onLocChanged: wttrProc.running = true
    Component.onCompleted: reload()

    Process {
        id: ipProc

        command: ["curl", "ipinfo.io"]
        stdout: StdioCollector {
            onStreamFinished: root.loc = JSON.parse(text).loc ?? ""
        }
    }

    Process {
        id: wttrProc

        command: ["curl", `https://wttr.in/${root.loc}?format=j1`]
        stdout: StdioCollector {
            onStreamFinished: {
                const json = JSON.parse(text).current_condition[0];
                root.icon = Icons.getWeatherIcon(json.weatherCode);
                root.description = json.weatherDesc[0].value;
                root.temperature = parseFloat(json.temp_C);
            }
        }
    }
}
