import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls

import ".."
import "../../"
import "../../functions/"

PopupWindow {
    id: root
    anchor.rect.x: (panel.width / 2 - width / 2)
    anchor.rect.y: panel.height + 15
    anchor.window: panel
    width: 950
    height: 350
    color: "transparent"

    property bool targetVisible: false

    mask: Region { item: mediaInterface }

    onTargetVisibleChanged: {
        if(targetVisible) {
            visible = true
            grab.active = true
            mediaInterface.y = 0
        }

        else {
            mediaInterface.opacity = 0
        }
    }

    HyprlandFocusGrab {
      id: grab
      windows: [ root, panel ]

      onCleared: {
          mediaInterface.opacity = 0
      }
    }

    Rectangle {
        id: mediaInterface
        width: parent.width
        height: 300
        radius: 15
        y: -parent.height
        color: "transparent"

        property int spacing: 40

        Rectangle {
            id: mediaImage
            radius: 15
            height: parent.height
            width: parent.width * 0.45
            anchors.left: parent.left
            z: 2
            color: Cfg.colors.primaryColor

            Image {
                id: sourceItem
                source: Mpris.albumImage
                anchors.left: parent.left
                width: parent.width
                height: parent.height
                visible: false
            }

            MultiEffect {
                source: sourceItem
                anchors.fill: sourceItem
                maskEnabled: true
                maskSource: mask
            }

            Item {
                id: mask
                width: sourceItem.width
                height: sourceItem.height
                layer.enabled: true
                visible: false

                Rectangle {
                    width: sourceItem.width
                    height: sourceItem.height
                    radius: 15
                    color: "black"
                }
            }
        }

        Rectangle {
            id: controls
            color: Cfg.colors.secondaryColor
            radius: 15
            height: parent.height
            width: parent.width * 0.15
            z: 1
            anchors {
                left: mediaImage.right
                leftMargin: -25
            }

            ColumnLayout {
                id: test
                height: parent.height
                width: parent.width + parent.anchors.leftMargin
                anchors.right: parent.right
                spacing: -50

                Rectangle {
                    width: 40
                    height: 40
                    radius: 5
                    color: "transparent"
                    Layout.alignment: Qt.AlignHCenter

                    Text {
                        text: ""
                        anchors.centerIn: parent
                        font.pixelSize: 32
                        font.family: Cfg.font
                        color: "white"

                        ClickableIcon {
                            icon: parent

                            onClicked: {
                                Mpris.backClick()
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }
                }

                Rectangle {
                    width: 40
                    height: 40
                    radius: 5
                    color: "transparent"
                    Layout.alignment: Qt.AlignHCenter 

                    Text {
                        text: Mpris.mediaStatus
                        anchors.centerIn: parent
                        font.pixelSize: 32
                        font.family: Cfg.font
                        color: "white"

                        ClickableIcon {
                            icon: parent

                            onClicked: {
                                if(Mpris.playing == false) {
                                    Mpris.playClick()
                                }

                                else {
                                    Mpris.pauseClick()
                                }
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }
                }

                Rectangle {
                    width: 40
                    height: 40
                    radius: 5
                    color: "transparent"
                    Layout.alignment: Qt.AlignHCenter 

                    Text {
                        text: ""
                        anchors.centerIn: parent
                        font.pixelSize: 32
                        font.family: Cfg.font
                        color: "white"

                        ClickableIcon {
                            icon: parent

                            onClicked: {
                                Mpris.nextClick()
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            color: Cfg.colors.primaryFixedDim
            radius: 15
            height: parent.height
            z: 0
            anchors {
                right: parent.right
                left: controls.right
                leftMargin: -25
            }

            ColumnLayout {
                id: mediaInfo
                height: parent.height
                width: mediaInterface.width - mediaImage.width - controls.width - parent.anchors.leftMargin
                anchors.right: parent.right

                Item {
                    Layout.preferredHeight: childrenRect.height
                    Layout.fillWidth: true

                    Text {
                        text: Mpris.mediaPosition + " / " + Mpris.mediaLength
                        anchors.centerIn: parent
                        font.pixelSize: 20
                        font.bold: true
                        font.family: Cfg.font
                        color: "white"
                    }
                }

                Item {
                    id: artistWrap
                    Layout.preferredHeight: childrenRect.height
                    Layout.fillWidth: true
                    clip: true

                    Text {
                        id: artist
                        text: Mpris.artist
                        x: (parent.width / 2) - (width / 2)
                        font.pixelSize: 24
                        font.bold: true
                        font.family: Cfg.font
                        color: "white"

                        Text {
                            x: movingArtist.running ? artist.width + mediaInterface.spacing : artistWrap.width
                            text: artist.text
                            font.pixelSize: parent.font.pixelSize
                            font.family: parent.font.family
                            font.bold: parent.font.bold
                            color: parent.color
                        }

                        NumberAnimation {
                            id: movingArtist
                            running: false
                            target: artist
                            property: "x"
                            from: 0
                            to: -artist.width - mediaInterface.spacing
                            duration: artist.width * 9
                            loops: Animation.Infinite
                        }

                        onWidthChanged: {
                            if(width > mediaInfo.width) {
                                movingArtist.running = true
                            }

                            else {
                                movingArtist.running = false
                            }
                        }
                    }
                }

                Item {
                    id: titleWrap
                    Layout.preferredHeight: childrenRect.height
                    Layout.fillWidth: true
                    clip: true

                    Text {
                        id: title
                        text: Mpris.mediaTitle
                        x: (parent.width / 2) - (width / 2)
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: 20
                        font.family: Cfg.font
                        color: "white"

                        Text {
                            x: movingTitle.running ? title.width + mediaInterface.spacing : titleWrap.width
                            text: title.text
                            font.pixelSize: parent.font.pixelSize
                            font.family: parent.font.family
                            color: parent.color
                        }

                        NumberAnimation {
                            id: movingTitle
                            running: false
                            target: title
                            property: "x"
                            from: 0
                            to: -title.width - mediaInterface.spacing
                            duration: title.width * 9
                            loops: Animation.Infinite
                        }

                        onWidthChanged: {
                            if(width > mediaInfo.width) {
                                movingTitle.running = true
                            }

                            else {
                                movingTitle.running = false
                            }
                        }
                    }
                }

                Slider {
                    id: mediaPos
                    value: Mpris.trackedPlayer != null ? Mpris.trackedPlayer.position : 0
                    to: Mpris.trackedPlayer != null ? Mpris.trackedPlayer.length : 0
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width - 20
                    Layout.preferredHeight: 25
                    clip: true

                    onValueChanged: {
                        if(pressed) {
                            Mpris.trackedPlayer.position = value
                        }
                    }

                    Connections {
                        target: Mpris.trackedPlayer

                        function onPositionChanged() {
                            if(!mediaPos.pressed) {
                                mediaPos.value = Mpris.trackedPlayer.position
                            }
                        }
                    }

                    background: Rectangle {
                        width: mediaPos.availableWidth
                        height: 15
                        radius: 6
                        clip: true
                        color: Cfg.colors.secondaryColor

                        Rectangle {
                            width: mediaPos.visualPosition * parent.width
                            height: parent.height
                            clip: true
                            radius: 4
                            color: Cfg.colors.errorContainer
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
                mediaPopup.active = false
                mediaPopup.loading = true
            }
        }
    }
}
