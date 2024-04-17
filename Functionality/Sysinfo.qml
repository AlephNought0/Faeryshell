pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property real total: 1
    property real free: 1
    property string used: "0%"
    property string cpuUsage: "0G"

    Process {
        id: mem
        running: true
        command: ["sh", "-c", "cat cat /proc/meminfo"]

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var lines = data.split("\n")
                root.total = parseInt(lines[0].match(/\d+/g))
                root.free = parseInt(lines[2].match(/\d+/g))
                var used = parseFloat((total - free) / 1000000).toFixed(1)
                root.used = used.toString() + "G"
            }
        }
    }

    Process {
        id: cpu
        running: true
        command: ["sh", "-c", "top -bn1 | sed -n '/Cpu/p' | awk '{print $2}' | sed 's/..,//'"]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                var lines = data.split("\n")
                root.cpuUsage = data.toString() + "%"
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            mem.running = true
            cpu.running = true
        }
    }
}