import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import ".."
import "../.."
import "../../Functionality"

PopupWindow {
    id: root
    parentWindow: panel

    relativeX: parentWindow.width - width - 20
    relativeY: Main.barHeight + 15
    width: 450
    height: 170
    color: "transparent"

    mask: Region { item: audioControl; }

    property bool targetVisible: false

    onTargetVisibleChanged: {
        if(targetVisible == true) {
            audioControl.opacity = 1
            showAudio.running = true
            visible = true
        }

        else {
            hideAudio.running = true
        }
    }

    NumberAnimation {
        id: showAudio
        target: audioControl
        property: "y"
        from: -200
        to: 0
        duration: 400
        easing.type: Easing.OutBack
    }

    NumberAnimation {
        id: hideAudio
        target: audioControl
        property: "opacity"
        from: 1
        to: 0
        duration: 150
    }

    Rectangle {
        id: audioControl
        width: parent.width
        height: 150
        radius: 10
        color: "purple"

        onOpacityChanged: {
            if(opacity == 0) {
                root.visible = false
            }
        }
    }
}