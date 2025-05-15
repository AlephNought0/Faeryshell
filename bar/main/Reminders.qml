import QtQuick
import QtQuick.Layouts

import "../.."

ColumnLayout {
    width: stack.width
    height: stack.width
    spacing: 20

    Rectangle {
        width: 275
        height: 65
        radius: 15
        color: "pink"
        Layout.alignment: Qt.AlignHCenter

        RowLayout {
            spacing: 5
            anchors.centerIn: parent

            Text {
                text: "Create a new reminder"
                font.family: Cfg.font
                font.pixelSize: 18
                font.bold: true
                color: "white"
                Layout.alignment: Qt.AlignVCenter
            }

            Rectangle {
                width: 25
                height: 25
                radius: 25
                color: "black"
                Layout.alignment: Qt.AlignVCenter

                Text {
                    anchors.centerIn: parent
                    text: "+"
                    color: "white"
                    font.family: Cfg.font
                    font.pixelSize: 25
                }
            }
        }
    }

    Rectangle {
        width: 325
        height: 5
        radius: 10
        color: "grey"
        Layout.alignment: Qt.AlignHCenter
    }
}
