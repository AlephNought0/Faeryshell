pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property real capacity

    Process {
        id: capacity
        running: true
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity"]

        stdout: SplitParser {
            onRead: data => {
                root.capacity = parseInt(data) * (13 / 100)
                console.log(root.capacity)
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            capacity.running = true
        }
    }
}