import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    height: parent.height
    anchors.centerIn: parent
    
    Rectangle {
        anchors.centerIn: parent
        width: 190
        height: parent.height - 5
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
            text: "Media"
            color: "white"
            font.pixelSize: 16  
            font.weight: 550
        }
    }
}