pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property real capacity

    Process {
        id: bat
        running: true
        command: ["cat", "/sys/class/power_supply/BAT0/capacity"]

        stdout: SplitParser {
            onRead: data => {
                root.capacity = parseInt(data) * (13 / 100)
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            bat.running = true
        }
    }
}