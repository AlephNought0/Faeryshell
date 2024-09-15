pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire

Singleton {
    property QtObject colors
    property QtObject pipewire

    property string font: "JetBrainsMono NerdFont"

    property UPowerDevice bat: UPower.displayDevice

    PwObjectTracker {
        objects: [
            Pipewire.defaultAudioSink,
            Pipewire.defaultAudioSource
        ]
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
