import QtQuick
import QtQuick.Layouts

import "../../"

RowLayout {
    spacing: 10

    Rectangle {
        width: 200
        height: panel.exclusiveZone - 5
        border.color: "black"
        border.width: 1.5
        radius: 10
        color: "purple"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                parent.color = "grey"
            }

            onExited: {
                parent.color = "purple"
            }
        }
    }

    Rectangle {
        Layout.preferredWidth: sysInfo.width + 30
        height: panel.exclusiveZone - 5
        border.color: "black"
        border.width: 1.5
        radius: 10
        color: "purple"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                parent.color = "grey"
            }

            onExited: {
                parent.color = "purple"
            }
        }

        RowLayout {
            id: sysInfo
            spacing: 10
            anchors.centerIn: parent


            RowLayout {
                Text {
                    text: ""
                    font.pixelSize: 20
                    font.family: Cfg.font
                    color: "white"
                }

                Text {
                    text: "0.1%"
                    font.pixelSize: 20
                    font.family: Cfg.font
                    color: "white"
                }
            }

            RowLayout {
                Text {
                    text: ""
                    font.pixelSize: 20
                    font.family: Cfg.font
                    color: "white"
                }

                Text {
                    text: "1.3G"
                    font.pixelSize: 20
                    font.family: Cfg.font
                    color: "white"
                }
            }
        }
    }
}
