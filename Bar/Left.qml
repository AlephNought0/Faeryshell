import Quickshell
import QtQuick
import QtQuick.Layouts
import "../Functionality"


RowLayout {
    height: 35
    anchors.left: parent.left
    spacing: 10

    Tray{}

    Rectangle { // Usage
        width: 160
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

        RowLayout {
            height: parent.height
            anchors.centerIn: parent
            spacing: 10


            RowLayout {
                height: parent.height
                Layout.alignment: Qt.AlignLeft

                Rectangle {
                height: parent.height
                width: childrenRect.width
                color: "transparent"

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        sourceSize.width: 15
                        sourceSize.height: parent.height - 16
                        fillMode: Image.PreserveAspectFit
                        source: "../icons/ram.svg"
                    }
                }

                Text {
                    text: Sysinfo.used
                    color: "white"
                    font.pixelSize: 16  
                    font.weight: 550
                }
            }

            RowLayout {
                height: parent.height
                Layout.alignment: Qt.AlignRight

                Rectangle {
                height: parent.height
                width: childrenRect.width
                color: "transparent"

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        sourceSize.width: 15
                        sourceSize.height: parent.height - 12
                        fillMode: Image.PreserveAspectFit
                        source: "../icons/cpu.svg"
                    }
                }

                Text {
                    text: Sysinfo.cpuUsage
                    color: "white"
                    font.pixelSize: 16  
                    font.weight: 550
                }
            }
        }
    }
}
