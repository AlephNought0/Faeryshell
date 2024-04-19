import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    width: 180
    height: 30
    radius: 10
    color: "purple"

    MouseArea {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        hoverEnabled: true

        onEntered: {
            parent.color = "grey"
        }

        onExited: {
            parent.color = "purple"
        }
    }

    Text {
        anchors.centerIn: parent
        text: "Tray"
        color: "white"
        font.pixelSize: 16
        font.weight: 550
    }
}
