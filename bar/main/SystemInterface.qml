import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import ".."
import "../../"
import "../../functions/"

PopupWindow {
    id: root
    anchor.rect.x: panel.width - width
    anchor.rect.y: panel.height + 15
    anchor.window: panel
    width: 900
    height: 500
    color: "transparent"

    property bool targetVisible: false

    mask: Region { item: systemInterface }

    onTargetVisibleChanged: {
        if(targetVisible) {
            visible = true
            grab.active = true
            systemInterface.x = 0
        }

        else {
            systemInterface.opacity = 0
        }
    }

    HyprlandFocusGrab {
        id: grab
        windows: [ root, panel ]

        onCleared: {
            systemInterface.opacity = 0 
        }
    }

    RowLayout {
        id: systemInterface
        width: parent.width
        height: parent.height
        x: parent.width + width

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            spacing: 10

            Rectangle {
                id: weather
                radius: 10
                Layout.preferredWidth: 350
                Layout.preferredHeight: 125
                color: "purple"

                RowLayout {
                    anchors.fill: parent
                    spacing: 5

                    Image {
                        sourceSize.width: 100
                        sourceSize.height: 100
                        source: Weather.icon
                    }

                    ColumnLayout {
                        Text {
                            text: Weather.weather
                            font.family: Cfg.font
                            font.bold: true
                            font.pixelSize: 20
                            color: "white"
                        }

                        Text {
                            text: Weather.temp
                            font.family: Cfg.font
                            font.pixelSize: 16
                            color: "white"
                        }
                    }
                }
            }

            Rectangle {
                id: test
                radius: 10
                Layout.preferredWidth: 350
                Layout.preferredHeight: 125
                color: "purple"
            }
        }

        Rectangle {
            id: main
            radius: 15
            Layout.fillHeight: true
            Layout.preferredWidth: 350
            color: "purple"
        }

        Rectangle {
            id: controls
            radius: 15
            Layout.fillHeight: true
            Layout.preferredWidth: 150
            color: "purple"

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Repeater {
                    model: 4

                    ProgressButton {
                        progress: modelData / 10
                    }
                }
            }
        }

        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutQuad
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }

        onOpacityChanged: {
            if(opacity == 0) {
                grab.active = false
                sysPopup.active = false
                sysPopup.loading = true
            }
        }
    }
}
