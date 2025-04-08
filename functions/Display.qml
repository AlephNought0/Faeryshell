pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtCore

import ".."

Singleton {
    property real brightness
    property int temperature
    property int nightTemperature
    property int tempNightVal
    property bool autoNightMode
    property bool setNight
    property bool isNight: !Cfg.time.isDay

    Settings {
        id: values

        property bool autoNight: autoNightMode
        property bool autoSetNight: setNight
        property int nightTemp: tempNightVal
    }

    function autoNight() {
        if(autoNightMode && isNight) {
            changeTemp.running = true;
            setNight = true;
        }

        Weather.init.disconnect(autoNight)
    }

    Component.onCompleted: {
        autoNightMode = values.autoNight;
        nightTemperature = values.nightTemp;
        tempNightVal = values.nightTemp;
        setNight = values.autoSetNight

        Weather.init.connect(autoNight)
    }

    onTempNightValChanged: {
        if(setNight) {
            nightTemperature = tempNightVal;
            changeTemp.running = true;
        }
    }

    onSetNightChanged: {
        if(setNight) {
            nightTemperature = values.nightTemp;
            changeTemp.running = true;
        }

        else {
            nightTemperature = 6500;
            changeTemp.running = true;
        }
    }

    onBrightnessChanged: {
        brightnessDelay.running = true;
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
        command: ["sh", "-c", `busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q ${nightTemperature}`]
        
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
                var val = data.split("\n");
                var i = val[0].split(" ");
                brightness = parseInt(i[0]) / 100;
                temperature = parseInt(i[1]);
            }
        }
    }
}
