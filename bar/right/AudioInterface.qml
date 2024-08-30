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
    width: 550
    height: 250
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
        color: "purple"

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
                        color: "grey"

                        Text {
                            text: Pipewire.defaultAudioSink.description
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
                    text: Math.floor((Pipewire.defaultAudioSink.audio.volume * 100)) == 0 ||
                    Pipewire.defaultAudioSink.audio.muted ? "" : ""
                    font.family: Cfg.font
                    font.pixelSize: 20
                    color: "white"
                    Layout.column: 1
                    Layout.row: 1

                    ClickableIcon {
                        icon: parent

                        onClicked: {
                            Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
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
                    value: Pipewire.defaultAudioSink.audio.volume
                    Layout.column: 0
                    Layout.row: 2
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    Layout.preferredHeight: 25

                    onValueChanged: {
                        if(pressed) {
                            Pipewire.defaultAudioSink.audio.volume = value
                        }
                    }

                    background: Rectangle {
                        width: output.availableWidth
                        height: 15
                        radius: 6
                        clip: true
                        color: "#bdbebf"

                        Rectangle {
                            width: output.visualPosition * parent.width
                            height: parent.height
                            color: "#21be2b"
                            radius: 6
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
                        color: "grey"

                        Text {
                            text: Pipewire.defaultAudioSource.description
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
                        text: Math.floor((Pipewire.defaultAudioSource.audio.volume * 100)) == 0 || 
                        Pipewire.defaultAudioSource.audio.muted ? "" : ""
                        font.family: Cfg.font
                        font.pixelSize: 24
                        color: "white"
                        Layout.column: 1
                        Layout.row: 1
                        x: Pipewire.defaultAudioSource.audio.muted ? -6.5 : 0

                        ClickableIcon {
                            icon: parent

                            onClicked: {
                                Pipewire.defaultAudioSource.audio.muted = !Pipewire.defaultAudioSource.audio.muted
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
                    value: Pipewire.defaultAudioSource.audio.volume
                    Layout.column: 0
                    Layout.row: 2
                    Layout.columnSpan: 3
                    Layout.fillWidth: true
                    Layout.preferredHeight: 25
                    clip: true

                    onValueChanged: {
                        if(pressed) {
                            Pipewire.defaultAudioSource.audio.volume = value
                        }
                    }

                    background: Rectangle {
                        width: input.availableWidth
                        height: 15
                        radius: 6
                        clip: true
                        color: "#bdbebf"

                        Rectangle {
                            width: input.visualPosition * parent.width
                            height: parent.height
                            clip: true
                            radius: 6
                            color: "#21be2b"
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
