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
    property var currSelected

    mask: Region { item: systemInterface }

    onTargetVisibleChanged: {
        if(targetVisible) {
            visible = true
            systemInterface.opacity = 1
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
        x: parent.width + width //I have no idea how this makes sense
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
                            text: Weather.currentTime === "night" && Weather.weather === "Sunny" ? "Night" : Weather.weather
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

        Rectangle {
            id: main
            radius: 15
            Layout.preferredHeight: 500 
            Layout.preferredWidth: 380
            color: Cfg.colors.primaryFixedDim
            clip: true

            StackView {
                id: stack
                initialItem: bright
                anchors.fill: parent

                replaceEnter: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: -stack.width * 1.5
                        to: 0
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

                replaceExit: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: 0
                        to: stack.width * 1.5
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }
            }

            Component {
                id: bright

                Brightness {}
            }

            Component {
                id: calendarus

                Cal {}
            }
        }

        Rectangle {
            id: controls
            radius: 15
            Layout.fillHeight: true
            Layout.preferredWidth: 150
            color: Cfg.colors.primaryFixedDim

            property int dayValue: new Date(parseInt(Cfg.time.year), parseInt(Cfg.time.month), 0).getDate()
            property string currItem

            property var buttons: [
                { button: "internet", value: 0.4, icon: "󰖩" },
                { button: "brightness", value: Display.brightness, icon: "󰃠" },
                { button: "bluetooth", value: 0, icon: ""},
                { button: "calendar", value: parseInt(Cfg.time.day) / dayValue, icon: "󰸗" }
            ]

            signal currWidget(string val)

            Connections {
                target: controls
                function onCurrWidget(val) {
                    if(val === controls.currItem) {
                        return
                    }

                    else if(val === "brightness") {
                        stack.replaceCurrentItem(bright)
                        controls.currItem = val
                    }

                    else if(val === "calendar") {
                        stack.replaceCurrentItem(calendarus)
                        controls.currItem = val
                    }
                }
            }

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
                        button: modelData.button
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
                x = root.width + width
                root.visible = false
                root.targetVisible = false
            }
        }
    }
}
