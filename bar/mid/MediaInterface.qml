import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import "../../"
import "../../functions/"

PopupWindow {
    anchor.rect.x: panel.width / 2 - width / 2
    anchor.rect.y: panel.exclusiveZone + 15
    anchor.window: panel
    width: 900
    height: 350
    color: "transparent"

    property bool targetVisible: false

    mask: Region { item: mediaInterface }

    onTargetVisibleChanged: {
        if(targetVisible) {
            visible = true;
            mediaInterface.y = 0
        }

        else {
            mediaInterface.opacity = 0;
        }
    }

    Rectangle {
        id: mediaInterface
        width: parent.width
        height: 300
        radius: 15
        y: -parent.height
        layer.enabled: true
        color: "pink"

        property int spacing: 40

        Rectangle {
            id: mediaImage
            radius: 15
            height: parent.height
            width: parent.width * 0.45
            anchors.left: parent.left
            z: 2
            color: "purple"

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
            color: "orange"
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
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            parent.color = "grey"
                        }

                        onExited: {
                            parent.color = "transparent"
                        }

                        onClicked: {
                            Mpris.backClick()
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
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            parent.color = "grey"
                        }

                        onExited: {
                            parent.color = "transparent"
                        }

                        onClicked: {
                            if(Mpris.playing == false) {
                                Mpris.playClick()
                            }

                            else {
                                Mpris.pauseClick()
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
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            parent.color = "grey"
                        }

                        onExited: {
                            parent.color = "transparent"
                        }

                        onClicked: {
                            Mpris.nextClick()
                        }
                    }
                }
            }
        }

        Rectangle {
            color: "#06768D"
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
                        Layout.alignment: Qt.AlignHCenter
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
                            property: "x"
                            target: artist
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
                            property: "x"
                            target: title
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
                mediaPopup.active = false;
                mediaPopup.loading = true;
            }
        }
    }
}
