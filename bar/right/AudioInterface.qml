import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire

import ".."
import "../../"
import "../../functions/"

PopupWindow {
    id: root
    anchor.rect.x: (panel.width / 2 - width / 2) + 600
    anchor.rect.y: panel.height + 15
    anchor.window: panel
    implicitWidth: 550
    implicitHeight: 250
    color: "transparent"

    property bool targetVisible: false

    mask: Region { item: audioInterface }

    onTargetVisibleChanged: {
        if(targetVisible) {
            visible = true
            grab.active = true
            audioInterface.y = 0
        }

        else {
            audioInterface.opacity = 0
        }
    }

    HyprlandFocusGrab {
      id: grab
      windows: [ root, panel ]

      onCleared: {
          audioInterface.opacity = 0 
      }
    }

    Rectangle {
        id: audioInterface
        width: parent.width
        height: 200
        radius: 15
        y: -parent.height
        layer.enabled: true
        color: Cfg.colors.primaryFixedDim

        ColumnLayout {
            spacing: 10
            anchors {
                fill: parent
                topMargin: 10
                bottomMargin: 10
                leftMargin: 20
                rightMargin: 20
            }

            GridLayout {
                columns: 3
                rows: 2
                rowSpacing: 10
                columnSpacing: 30

                Item {
                    Layout.column: 0
                    Layout.row: 1
                    Layout.preferredWidth: 3
                    Layout.fillWidth: true
                    Layout.preferredHeight: 25

                    Rectangle {
                        height: 25
                        width: childrenRect.width + 15
                        radius: 5
                        color: Cfg.colors.thirdaryColor

                        Text {
                            text: Cfg.pipewire.sink != null ? Cfg.pipewire.sink.description : null
                            elide: Text.ElideRight
                            font.family: Cfg.font
                            font.pixelSize: 20
                            color: "white"
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 5
                            }

                            onWidthChanged: {
                                if(width > 400) {
                                    width = 400
                                }
                            }
                        }
                    }
                }

                Text {
                    text: Cfg.pipewire.sink != null ? (Math.floor((Cfg.pipewire.sink.audio.volume * 100)) == 0 ||
                    Cfg.pipewire.sink.audio.muted ? "" : "") : null
                    font.family: Cfg.font
                    font.pixelSize: 20
                    color: "white"
                    Layout.column: 1
                    Layout.row: 1

                    ClickableIcon {
                        icon: parent

                        onClicked: {
                            Cfg.pipewire.sink.audio.muted = !Cfg.pipewire.sink.audio.muted
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                }

                Text {
                    text: "󰍜"
                    font.family: Cfg.font
                    font.pixelSize: 30
                    color: "white"
                    Layout.column: 2
                    Layout.row: 1

                    ClickableIcon {
                        icon: parent
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                }

                Slider {
                    id: output
                    value: Cfg.pipewire.sink != null ? Cfg.pipewire.sink.audio.volume : null
                    Layout.column: 0
                    Layout.row: 2
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20

                    onValueChanged: {
                        if(pressed) {
                            Cfg.pipewire.sink.audio.volume = value
                        }
                    }

                    background: Rectangle {
                        height: parent.height
                        radius: 8
                        color: Cfg.colors.secondaryColor

                        Rectangle {
                            width: output.visualPosition * parent.width
                            height: parent.height
                            radius: 8
                            color: Cfg.colors.errorContainer

                            Behavior on width {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.OutQuad
                                }
                            }
                        }
                    }

                    handle: Rectangle {
                        color: "transparent"
                    }
                }
            }

            GridLayout {
                columns: 3
                rows: 2
                rowSpacing: 10
                columnSpacing: 30

                Item {
                    Layout.column: 0
                    Layout.row: 1
                    Layout.preferredWidth: 3
                    Layout.fillWidth: true
                    Layout.preferredHeight: 25

                    Rectangle {
                        height: 25
                        width: childrenRect.width + 15
                        radius: 5
                        color: Cfg.colors.thirdaryColor

                        Text {
                            text: Cfg.pipewire.source != null ? Cfg.pipewire.source.description : null
                            elide: Text.ElideRight
                            font.family: Cfg.font
                            font.pixelSize: 20
                            color: "white"
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 5
                            }

                            onWidthChanged: {
                                if(width > 400) {
                                    width = 400
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.column: 1
                    Layout.row: 1
                    height: childrenRect.height
                    width: 20

                    Text {
                        text: Cfg.pipewire.source != null ? (Math.floor((Cfg.pipewire.source.audio.volume * 100)) == 0 || 
                        Cfg.pipewire.source.audio.muted ? "" : "") : null
                        font.family: Cfg.font
                        font.pixelSize: 24
                        color: "white"
                        Layout.column: 1
                        Layout.row: 1
                        x: Cfg.pipewire.source != null ? (Cfg.pipewire.source.audio.muted ? -6.5 : 0) : null

                        ClickableIcon {
                            icon: parent

                            onClicked: {
                                Cfg.pipewire.source.audio.muted = !Cfg.pipewire.source.audio.muted
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }
                }

                Text {
                    text: "󰍜"
                    font.family: Cfg.font
                    font.pixelSize: 30
                    color: "white"
                    Layout.column: 2
                    Layout.row: 1

                    ClickableIcon {
                        icon: parent
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                }

                Slider {
                    id: input
                    value: Cfg.pipewire.source != null ? Cfg.pipewire.source.audio.volume : null
                    Layout.column: 0
                    Layout.row: 2
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20
                    clip: true

                    onValueChanged: {
                        if(pressed) {
                            Cfg.pipewire.source.audio.volume = value
                        }
                    }

                    background: Rectangle {
                        width: input.availableWidth
                        height: parent.height
                        radius: 8
                        clip: true
                        color: Cfg.colors.secondaryColor

                        Rectangle {
                            width: input.visualPosition * parent.width
                            height: parent.height
                            clip: true
                            radius: 8
                            color: Cfg.colors.errorContainer

                            Behavior on width {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.OutQuad
                                }
                            }
                        }
                    }

                    handle: Rectangle {
                        color: "transparent"
                    }
                }
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutBack
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
                audioPopup.active = false
                audioPopup.loading = true
            }
        }
    }
}
