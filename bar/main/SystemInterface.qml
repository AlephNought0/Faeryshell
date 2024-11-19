import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower
import Quickshell.Wayland

import ".."
import "../../"
import "../../functions/"

PopupWindow {
    id: root
    anchor.rect.x: panel.width - width
    anchor.rect.y: panel.height + 15
    anchor.window: panel
    width: systemInterface.width
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
        x: parent.width + width
        spacing: 10

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            spacing: 10

            Rectangle {
                id: weather
                radius: 10
                Layout.preferredWidth: 350
                Layout.preferredHeight: 125
                color: Cfg.colors.primaryFixedDim

                RowLayout {
                    spacing: 10
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }

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
                radius: 10
                Layout.preferredWidth: 350
                Layout.preferredHeight: 125
                color: Cfg.colors.primaryFixedDim

                Rectangle {
                    id: batteryWidget
                    width: parent.width - 60
                    height: 50
                    radius: 10
                    anchors.centerIn: parent
                    color: "#eff0ff"

                    Text {
                        text: ""
                        z: 2
                        font.family: Cfg.font
                        font.pixelSize: 32
                        color: "white"
                        anchors {
                            left: parent.left
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    Rectangle {
                        width: (parent.width - 10) * Cfg.bat.percentage
                        height: 44
                        radius: 8
                        color: Cfg.colors.primaryColor
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 4
                        }

                        Behavior on width {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }

                    Text {
                        text: `${Cfg.bat.percentage * 100}%`
                        font.family: Cfg.font
                        font.pixelSize: 20
                        color: "white"
                        anchors.centerIn: parent
                    }
                }                
            }
        }

        /*Rectangle {
            id: main
            radius: 15
            Layout.fillHeight: true
            Layout.preferredWidth: 350
            color: Cfg.primaryFixedDim
        }*/

        Rectangle {
            id: main
            radius: 15
            Layout.preferredHeight: childrenRect.height
            Layout.preferredWidth: childrenRect.width
            color: Cfg.colors.primaryFixedDim

            StackLayout {
                Brightness {}
            }
        }

        Rectangle {
            id: controls
            radius: 15
            Layout.fillHeight: true
            Layout.preferredWidth: 150
            color: Cfg.colors.primaryFixedDim

            property var buttons: [
                { button: "internet", value: 0.4, icon: "󰖩" },
                { button: "brightness", value: Display.brightness, icon: "󰃠" },
                { button: "bluetooth", value: 0, icon: ""},
                { button: "system", value: 1, icon: "" }
            ]

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Repeater {
                    model: controls.buttons

                    ProgressButton {
                        id: meow
                        required property var modelData

                        progress: modelData.value
                        icon: modelData.icon
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
