import Quickshell
import QtQuick
import QtQuick.Effects
import Quickshell.Io
import QtQuick.Layouts

import ".."
import "../.."
import "../../Functionality"


PopupWindow {
    id: mediaParent
    parentWindow: panel
    relativeX: parentWindow.width / 2 - width / 2
    relativeY: Main.barHeight + 15
    width: 500
    height: 220
    color: "transparent"

    mask: Region { item: mediaInterface; }

    property bool targetVisible: false

    onTargetVisibleChanged: {
        if(targetVisible == true) {
            mediaInterface.opacity = 1
            showMedia.running = true
            visible = true
        }

        else {
            hideMedia.running = true
        }
    }

    NumberAnimation {
        id: showMedia
        target: mediaInterface
        property: "y"
        from: -200
        to: 0
        duration: 400
        easing.type: Easing.OutBack
    }

    NumberAnimation {
        id: hideMedia
        target: mediaInterface
        property: "opacity"
        from: 1
        to: 0
        duration: 150
    }

    Rectangle {
        id: mediaInterface
        width: parent.width
        height: 200
        radius: 10
        color: "purple"

        onOpacityChanged: {
            if(opacity == 0) {
                mediaParent.visible = false
            }
        }

        Rectangle {
            id: mediaImage
            width: 200
            height: parent.height
            color: "purple"
            radius: 10
            z: 2

            Image {
                id: sourceItem
                source: Mpris.albumImage
                anchors.left: parent.left
                width: parent.width
                height: parent.height
                visible: false
                z: 2
            }

            MultiEffect {
                source: sourceItem
                anchors.fill: sourceItem
                maskEnabled: true
                maskSource: mask
                z: 2
            }

            Item {
                id: mask
                width: sourceItem.width
                height: sourceItem.height
                layer.enabled: true
                visible: false
                z: 2

                Rectangle {
                    width: sourceItem.width
                    height: sourceItem.height
                    radius: 10
                    color: "black"
                    z: 2
                }
            }
        }

        Rectangle {
            id: mediaControls
            width: 70
            height: parent.height
            radius: 10
            x: sourceItem.width - 15
            z: 1
            color: "pink"

            ColumnLayout {
                height: parent.height - 40
                width: parent.width - 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                Rectangle {
                    width: 25
                    height: 25
                    radius: 5
                    color: "transparent"

                    MouseArea {
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
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

                    Image {
                        width: parent.width - 10
                        height: parent.height - 10
                        anchors.centerIn: parent
                        source: "../../icons/backwards.svg"
                    }
                }

                Rectangle {
                    width: 25
                    height: 25
                    radius: 5
                    color: "transparent"

                    MouseArea {
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
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

                    Image {
                        width: parent.width - 10
                        height: parent.height - 10
                        anchors.centerIn: parent
                        source: Mpris.status
                    }
                }

                Rectangle {
                    width: 25
                    height: 25
                    radius: 5
                    color: "transparent"

                    MouseArea {
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
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

                    Image {
                        width: parent.width - 10
                        height: parent.height - 10
                        anchors.centerIn: parent
                        source: "../../icons/forward.svg"
                    }
                }
            }
        }

        Rectangle {
            height: parent.height
            width: parent.width
            radius: 10
            z: 0
            color: "#005C6F"

            ColumnLayout {
                height: 200
                width: parent.width - mediaImage.width - mediaControls.width
                anchors.right: parent.right

                Rectangle {
                    width: parent.width - 50
                    height: 40
                    Layout.alignment: Qt.AlignTop
                    color: "transparent"

                    Image {
                        id: currMedia
                        sourceSize.width: parent.height - 25
                        sourceSize.height: parent.height - 25
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        source: "../../icons/chromium.svg"
                    }

                    Text {
                        id: mediaIcon
                        text: "chromium"
                        anchors.verticalCenter: parent.verticalCenter
                        x: currMedia.width + 5
                        font.pixelSize: 14
                        font.weight: 650
                        font.family: Main.fontSource
                        color: "white"
                    }

                    Text {
                        text: Mpris.timeStatus
                        anchors.verticalCenter: parent.verticalCenter
                        x: currMedia.width + mediaIcon.width + 10
                        font.pixelSize: 14
                        font.weight: 650
                        font.family: Main.fontSource
                        color: "white"
                    }
                }

                Item {
                    id: middleText
                    height: childrenRect.height + 10
                    width: parent.height + 20
                    anchors.verticalCenter: parent.verticalCenter
                    clip: true

                    property string spacing: " " 
                    property int aStep: 0
                    property int mStep: 0
                    property string mTitle: Mpris.mediaTitle
                    property string mCombined: mTitle + spacing
                    property string mDisplay: mCombined.substring(mStep) + mCombined.substring(0, mStep)
                    property string aArtist: Mpris.artist
                    property string aCombined: aArtist + spacing
                    property string aDisplay: aCombined.substring(aStep) + aCombined.substring(0, aStep)

                    Timer {
                        id: timer
                        interval: 200
                        running: false
                        repeat: true
                        onTriggered: {
                            parent.aStep = (parent.aStep + 1) % parent.aCombined.length
                        } 
                    }

                    Timer {
                        id: timerS
                        interval: 200
                        running: false
                        repeat: true
                        onTriggered: {
                            parent.mStep = (parent.mStep + 1) % parent.mCombined.length
                        } 
                    }

                    Timer {
                        id: textCheck
                        interval: 200
                        running: false
                        onTriggered: {
                            
                            if(artistText.width > parent.width + 12) {
                                timer.running = true
                            }

                            else {
                                parent.aStep = 0
                                timer.running = false
                            }

                            if(titleText.width > parent.width + 12) {
                                timerS.running = true
                            }

                            else {
                                parent.mStep = 0
                                timerS.running = false
                            }
                        } 
                    }

                    ColumnLayout {

                        Text {
                            id: artistText
                            font.pixelSize: 28
                            font.weight: 700
                            font.family: Main.fontSource
                            color: "white"
                            text: middleText.aDisplay

                            onWidthChanged: {
                                textCheck.running = true
                            }
                        }

                        Text {
                            id: titleText
                            font.pixelSize: 20
                            font.weight: 650
                            font.family: Main.fontSource
                            color: "white"
                            text: middleText.mDisplay

                            onWidthChanged: {
                                textCheck.running = true
                            }
                        }
                    }
                }
            }
        }
    }
}
