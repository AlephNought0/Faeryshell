import Quickshell
import QtQuick
import QtQuick.Layouts
import "../Functionality"
import ".."


RowLayout {
    height: 30
    anchors.bottom: parent.bottom
    x: 10
    spacing: 10

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
            font.pixelSize: 14
            font.weight: 650
            font.family: Main.fontSource
        }
    }

    Rectangle { // Usage
        width: 160
        height: parent.height
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
                    font.pixelSize: 14
                    font.weight: 650
                    font.family: Main.fontSource
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
                    font.pixelSize: 14
                    font.weight: 650
                    font.family: Main.fontSource
                }
            }
        }
    }
}
