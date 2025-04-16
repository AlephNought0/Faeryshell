pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire

Singleton {
    property QtObject colors
    property QtObject pipewire
    property QtObject time

    property string font: "JetBrainsMono NerdFont"

    property UPowerDevice bat: UPower.displayDevice

    SystemClock {
        id: clock
    }

    PwObjectTracker {
        objects: [
            Pipewire.defaultAudioSink,
            Pipewire.defaultAudioSource
        ]
    }

    time: QtObject {
        property string hours: clock.hours
        property string minutes: clock.minutes
        property string seconds: clock.seconds
        property string day: new Date().getDate()
        property string month: new Date().getMonth() + 1
        property string year: new Date().getFullYear()
        property string part
        property bool isNight: false
    }

    colors: QtObject {
        property string primaryColor
        property string primaryFixedDim
        property string secondaryColor
        property string thirdaryColor //haha get it?
        property string errorContainer
    }

    pipewire: QtObject {
        property var sink: Pipewire.defaultAudioSink
        property var source: Pipewire.defaultAudioSource
    }
} 
