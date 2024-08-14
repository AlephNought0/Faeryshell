import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    width: row.width
    height: row.height
    radius: 10
    color: "transparent"
    anchors.centerIn: parent

    required property var entry

    /*MouseArea {
        width: parent.width
        height: parent.height
        hoverEnabled: true

        onEntered: {
            parent.color = "gray"
        }

        onExited: {
            parent.color = "transparent"
        }
    }*/

    RowLayout {
        id: row

        Item {
            implicitWidth: 22
            implicitHeight: 22

            Rectangle {
                width: 10
                height: 10
                anchors.centerIn: parent
            }          
        }

        Text {
            text: entry.text
            color: entry.enabled ? "white" : "#bbbbbb"
        }
    }
}


