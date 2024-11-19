pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property real brightness
    property real initBrightness
    property int temperature
    property int nightTemperature
    property int nTempVal
    property bool night

    onNightChanged: {
        if(night == true) {
            nTempVal = nightTemperature
            changeTemp.running = true
        }

        else {
            nTempVal = 6500
            changeTemp.running = true
        }
    }

    onNightTemperatureChanged: {
        if(night) {
            nTempVal = nightTemperature
            changeTemp.running = true
        }
    }

    onBrightnessChanged: {
        brightnessDelay.running = true
    }

    Timer {
        id: brightnessDelay
        interval: 25
        repeat: false
        running: false

        onTriggered: {
            changeBrightness.running = true
        }
    }

    Process {
        id: changeTemp
        running: false
        command: ["sh", "-c", `busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q ${nTempVal}`]
        
    }

    Process {
        id: changeBrightness
        running: false
        command: ["sh", "-c", `busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d ${brightness}`]
    }

    Process {
        id: monBrightness
        command: ["wl-gammarelay-rs", "watch", "{bp} {t}"]
        running: true

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var val = data.split("\n")
                var i = val[0].split(" ")
                brightness = (Number(i[0]) / 100)
                temperature = Number(i[1])
            }
        }
    }
}
